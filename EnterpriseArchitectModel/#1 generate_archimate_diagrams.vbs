!INC Local Scripts.EAConstants-VBScript
!INC EAScriptLib.VBScript-XML

dim theGuidMapping
set theGuidMapping = CreateObject( "Scripting.Dictionary" )

dim theDiagramsDefinition
set theDiagramsDefinition = CreateObject( "Scripting.Dictionary" )

dim theDiagramsDescription
set theDiagramsDescription = CreateObject( "Scripting.Dictionary" )

sub GetDiagramsDefinition(file)

	dim strLine
	dim TextLine
	
	dim objStream
	Set objStream = CreateObject("ADODB.Stream")
	
	objStream.CharSet = "utf-8"
	objStream.Open
	objStream.LoadFromFile( file )
	objStream.LineSeparator = 13
	
	theDiagramsDefinition.RemoveAll
	theDiagramsDescription.RemoveAll

	do until objStream.EOS
		strLine = objStream.ReadText(-2)

		TextLine = strLine
		TextLine = Replace(TextLine, "'", "")
		TextLine = Replace(TextLine, "[", "")
		TextLine = Replace(TextLine, "]", "")
		
		Session.Output ( TextLine )
		
		dim Diagram
		dim Keys
		dim Description
		dim Guids
		
		Diagram = Split(TextLine, ";")
		
		if ubound(Diagram) > 1 then
			Guids = Replace(Diagram(1), " ", "")
			Description = Diagram(2)
			
			Session.Output( "Diagram: " & Diagram([0]) )
			
			theDiagramsDefinition.Add Diagram([0]), Guids
			theDiagramsDescription.Add Diagram([0]), Description
		end if
	loop
	
	objStream.Close

	theDiagramsDefinition.Remove "DiagramName"
	theDiagramsDescription.Remove "DiagramName"
	
	Session.Output( "Diagram definition has been loaded from file: " & file )
	
end sub

sub GenerateDiagrams(diagramPackageName, note, technology)

	' Create a new package in the first model node
	dim modelNode as EA.Package
	set modelNode = Repository.Models.GetAt( 0 )
		
	dim viewPackage as EA.Package
	set viewPackage = nothing

	dim package as EA.Package
	for each package in modelNode.Packages
		if package.Name = diagramPackageName then
			set viewPackage = package
			
			Session.Output( "Reuse package '" & viewPackage.Name &  "'")
			exit for
		end if
	next
	
	if viewPackage is nothing then
		set viewPackage = modelNode.Packages.AddNew( diagramPackageName, "Application Layer Diagram" )
		viewPackage.Notes = note
		viewPackage.Update()
		
		Session.Output( "Added new package '" & viewPackage.Name & "' to model" )
	end if

	dim allKeys
	allKeys = theDiagramsDefinition.Keys
	
	for each item in allKeys
	
		' Create a diagram in the package
		dim diagram as EA.Diagram
		set diagram = nothing
		
		for each d in viewPackage.Diagrams
			if d.Name = item then
				set diagram = d
			
				Session.Output( "Reuse diagram '" & diagram.Name &  "'")
			exit for
		end if
		next
		
		if diagram is nothing then		
			if technology = "ArchiMate3" then
				set diagram = viewPackage.Diagrams.AddNew( item, "Application Layer" )
				diagram.StyleEx = "MDGDgm=ArchiMate3::Application;"
			elseif technology = "SOA" then
				set diagram = viewPackage.Diagrams.AddNew( item, "Component" )
				diagram.StyleEx = "MDGDgm=SOA Diagrams::SOA Solution Diagram;"
			end if

			diagram.Notes = theDiagramsDescription (item)
			diagram.Update()
		
			Session.Output( "Added diagram '" & diagram.Name & "' to package " & viewPackage.Name )
		end if
		
		Keys = Split(theDiagramsDefinition (item), ",")
		
		for i = LBound(Keys) To UBound(Keys)  
			dim element as EA.Element
			
			Session.Output("Keys(i): " & Keys(i) )
			elementId = theGuidMapping(Keys(i))
			
			On Error REsume NEXT
			Session.Output("elementId: " & elementId )
			set element = GetElementById( elementId )

			' Add the element to the diagram
			dim diagramObjects as EA.Collection
			set diagramObjects = diagram.DiagramObjects
			
			dim diagramObject as EA.DiagramObject
			set diagramObject = diagramObjects.AddNew( "","" )
			
			if element.Type = "BusinessActor" then
				diagramObject.Style = "UCRect=1;"
			else
				diagramObject.Style = "UCRect=0;"
			end if
			
			diagramObject.ElementID( element.ElementID )
			diagramObject.Update()
		next 
		
		' Diagram layout
		Repository.GetProjectInterface.LayoutDiagramEx diagram.DiagramGUID, lsDiagramDefault, 8, 20 , 20, false
		
		CloseDiagram (diagram.DiagramID)
		
		Session.Output( "Added elements to diagram " & diagram.Name )
	next
		
end sub

sub GetElementsGuidMapping(tagName)
	
	dim sql
	dim element as EA.Element
	dim neoId
	dim objectId
	dim alias
	dim i
	
	' Get neoId, elementId and Alias
	sql = "SELECT a.Value AS NEO_ID, a.Object_ID, (SELECT b.Value FROM t_objectproperties AS b WHERE a.Object_ID = b.Object_ID AND b.Property = 'Alias') AS Alias FROM t_objectproperties AS a WHERE a.Property = 'GUID'"
	sql = "SELECT a.Value AS NEO_ID, a.Object_ID, (SELECT b.Value FROM t_objectproperties AS b WHERE a.Object_ID = b.Object_ID AND b.Property = 'Alias') AS Alias FROM t_objectproperties AS a WHERE a.Property = '" & tagName & "'"

	dim queryResult
	queryResult = Repository.SQLQuery( sql )
	if len(queryResult) > 0 then
	
		dim resultDOM 
		set resultDOM = XMLParseXML( queryResult )
		
		neoId = XMLGetNodeTextArray( resultDOM, "//EADATA//Dataset_0//Data//Row//NEO_ID" )
		objectId = XMLGetNodeTextArray( resultDOM, "//EADATA//Dataset_0//Data//Row//Object_ID" )
		alias = XMLGetNodeTextArray( resultDOM, "//EADATA//Dataset_0//Data//Row//Alias" )
		
		for i = lbound(neoId) to ubound(objectId)
			theGuidMapping.Add neoId(i), objectId(i)
			
			if len(alias(i)) > 0 then
				set element = GetElementByID(objectId(i))
				element.Alias = alias(i)
				element.Update
			end if
		next
		
	end if
	
	Session.Output( "Mapping between neoId and objectId was loaded" )
	Session.Output( "Alias from neo was updated." )
end sub

sub main1()
    ' Show the script output window
	Repository.EnsureOutputVisible "Script"

	GetElementsGuidMapping "GUID"
	
	path = "c:\Work\CSSZ\Model\ExportFromNeo4j\"
	
	GetDiagramsDefinition path & "links.csv"
	GenerateDiagrams "Obrazovky - pøechody", "Pøehled pøechodù mezi obrazovkami.", "ArchiMate3"
	
end sub

sub main()
	
	dim path

	' Show the script output window
	Repository.EnsureOutputVisible "Script"

	GetElementsGuidMapping "GUID"
	
	path = "c:\Work\CSSZ\Model\ExportFromNeo4j\"
	
	GetDiagramsDefinition path & "links.csv"
	GenerateDiagrams "Screens - transitions between screens", "Overview of transitions between screens.", "ArchiMate3"
	
	GetDiagramsDefinition path & "screens.csv"
	GenerateDiagrams "Screens", "Overview of screens.", "ArchiMate3"
	
	GetDiagramsDefinition path &  "roles.csv"
    GenerateDiagrams "Roles", "Overview of roles.", "ArchiMate3"
	
	GetDiagramsDefinition path & "fragments.csv"
	GenerateDiagrams "Fragments", "Overview of fragments.", "ArchiMate3"
	
end sub

main