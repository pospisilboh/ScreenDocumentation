# Automatic creation of system model with Neo4j

## Introduction
As is very common, there are legacy systems/applications without any documentation and their maintenance or further development isn't an easy task. This particular article outlines how to create documentation automatically with a minimum effort in form of ArchiMate model in **Sparx Enterprise Architect** or **Archi**. 

In our case, we will use graph database Neo4j and **automatically** create the application model that will describe basic entities as are **screens** (343 pcs), **fragments** (159 pcs), **roles** (36 pcs), **files** (465 pcs) and **relations** (1702 pcs) between them.

**HTML version** of automatically generated model is available [**here**](http://www.bobovo.eu/ScreenModel/index.html). It's an export from Sparx Enterprise Architect to HTML.

In analytic part using a graph database Neo4j we will identify:
- application communities
- communities where fragments are used
- communities with lower number of screens than roles
- the missing role setting in a linked screen
- unused parts of the application
- risk business processes

## Example

An illustrative example of two screens and its relations to screens, fragments, roles and files is below:

![Screen example](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example.jpg?raw=true")

There is only the source code of the application, but fortunately, there is a way (by source code scrapping) how to all required information can be obtained automatically. The code scrapping isn't the subject of this article and has to be implemented according to application.

The example of an outcome from the scrapping for one **screen** (Screen_414) in a **json** format is below:

![Screen example](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example_json.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example_json.jpg?raw=true")

The **json** definition of the **screen** (Screen_414) and its relations to screens, fragments, roles and files is possible to transform to a graph (nodes and relationships):

![Screen example](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example_json_graph.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_screen_example_json_graph.jpg?raw=true")

The **graph** (Screen_414) and its nodes and relationships is possible to represent as an Archimate model. There are two steps:
- an export graf to ArchiMate® 3.1 Model Exchange File definition
- an import ArchiMate® 3.1 Model Exchange File definition to **Sparx Enterprise Architect** or **Archi**

![Screen example](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/neo4j_graph_model.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/neo4j_graph_model.jpg?raw=true")

The example of **automatically** created documentation for the **screen** (Screen_414) in Sparx Enterprise Architect:

![Database schema](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_model_example.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_model_example.jpg?raw=true")

##  Solution architecture

The solution is a mix of the following technologies, tools, standards:
- Python
- Jupyter Notebook
- Neo4j (Neo4j Sandbox)
- Neo4j Bloom
- Neo4j APOC Library
- Graph Data Science Playground
- Cypher
- ArchiMate
- ArchiMate® 3.1 Model Exchange File definition
- Sparx Enterprise Architect
- Archi
- VB script

![Database schema](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_architecture.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_architecture.jpg?raw=true")

**Description of architecture components**

| Component | Description |
| :- | :------------- |
| Legacy application | An anonymous system/application for which the documentation will be created. |
| Source code scrapping | An implemented funkcionality. The file as an outcome from the application source code scrapping (in json format) containing information about screens, fragments, roles, files and relations between them. The code scrapping isn't the subject of this article. <p> <p> The anonymized file is available here:  [screenList_20210105_anonymized.json](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ImportFromFile/screenList_20210105_anonymized.json "File screenList_20210105_anonymized.json") |
| Python / Neo4j | The Python script in Jupyter Notebook using a graph database [Neo4j](https://neo4j.com/ "Neo4j graph database"). <p> There is a possibility to use [Sandbox](https://neo4j.com/sandbox/) and create new Neo4j database in less than 60 seconds. No download required. |
| Import definition to Neo4j | Part of the Python script. The script imports data from file [screenList_20210105_anonymized.json](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ImportFromFile/screenList_20210105_anonymized.json "File screenList_20210105_anonymized.json") to graph database Neo4j. |
| Generate ArchiMate model definition | Part of the Python script. The script creates valid file in format [ArchiMate® 3.1 Model Exchange File definition](https://www.opengroup.org/xsd/archimate/): <p><p>- [screen_model.xml](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screen_model.xml "File in format ArchiMate® 3.1 Model Exchange File definition") <p><p> The ArchiMate Model Exchange File Format is a standard file format that can be used to exchange ArchiMate models between tools that create or interpret ArchiMate models.The scope of the standard is restricted to the elements and the relationships of an ArchiMate model. It excludes features that are vendorspecific. |
| Generate model diagram definition | Part of the Python script.The script creates files with the definition of diagrams: <p><p>- [screens.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screens.csv)<p>- [roles.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/roles.csv) <p>- [fragments.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/fragments.csv) <p>- [links.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/links.csv) |
| Sparx Enterprise Architect | [Sparx Enterprise Architect](https://sparxsystems.com/ "Sparx Enterprise Architect") is a visual platform for designing and constructing software systems, for business process modeling, and for more generalized modeling purposes. |
| Create ArchiMate model | A native functionality of [Sparx Enterprise Architect](https://sparxsystems.com/ "Sparx Enterprise Architect").  We have a valid ArchiMate® 3.1 Model Exchange File. <p>It is possible to [import](https://sparxsystems.com/enterprise_architect_user_guide/15.2/model_domains/imparchmeff.html "Import ArchiMate® 3.1 Model Exchange File") generated file [screen_model.xml](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screen_model.xml "File in format ArchiMate® 3.1 Model Exchange File definition") into a [prepared](https://github.com/pospisilboh/ScreenDocumentation/blob/main/EnterpriseArchitectModel/model_template.eapx "Prepared EA file with VB script") Enterprise Architect project as a UML model. <p>To import an Open Exchange Format file, in Ribbon select the item **"Specialize > Technologies > ArchiMate > Import Model Exchange File"**. Click on Import button to import the selected Model Exchange file into the specified Package. |
| Create ArchiMate model diagrams | An implemented funkcionality by VB script [#1 generate_archimate_diagrams.vbs](https://github.com/pospisilboh/ScreenDocumentation/blob/main/EnterpriseArchitectModel/%231%20generate_archimate_diagrams.vbs "VBA script") in the [prepared](https://github.com/pospisilboh/ScreenDocumentation/blob/main/EnterpriseArchitectModel/model_template.eapx "Prepared EA file with VB script") Enterprise Architect project. The VB script generates diagrams  by definition in files: <p><p>- [screens.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screens.csv)<p>- [roles.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/roles.csv) <p>- [fragments.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/fragments.csv) <p>- [links.csv](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/links.csv) <p> To run the VB script, select context menu item "[Specialize->Scripts->#1 generate_archimate_diagrams](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_run_script.jpg "Run VB script")" |
| Archi | [Archi](https://www.archimatetool.com/ "Archi") is an open source modelling toolkit to create ArchiMate models and sketches. |
| Create ArchiMate model | A native functionality of [Archi](https://www.archimatetool.com/ "Archi"). <p>It is possible to [import](https://... "Import ArchiMate® 3.1 Model Exchange File") generated file [screen_model.xml](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screen_model.xml "File in format ArchiMate® 3.1 Model Exchange File definition") and create a new ArchiMate model. <p>To import an Open Exchange Format file, select the menu item **"File->Import->Open Exchange XML Model..."**. Select and open the required XML file. This will create a new ArchiMate model in the Models Tree. |
  
### Create ArchiMate model diagrams in Sparx Enterprise Architect

**Magic** how to automatically generate diagrams in Sparx Enterprise Architect is in the VB script [#1 generate_archimate_diagrams.vbs](https://github.com/pospisilboh/ScreenDocumentation/blob/main/EnterpriseArchitectModel/%231%20generate_archimate_diagrams.vbs "VBA script"). The VB script generates diagrams by definition in files:
- creates a new diagram, 
- inserts defined elements
- formats the layout of the elements in the diagram.

For example by following diagram definition:

<small>***DiagramName;NodeKeys;Documentation<p>Role_1269;['NEOID_3e19fa29-bae1-48da-88bc-d1ffa17c4a8a', 'NEOID_9f0d17d0-9076-452b-90cd-c64fc6892f60'];The diagram describes the role Role_1269.***</small>

a following diagram is generated:

![Database schema](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_diagram.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_diagram.jpg?raw=true") 

## Graph database schema

The graph consists of 343 screens, 159 fragments, 36 roles and 465 files. A visual scheme of our graph database is given below.

![Database schema](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/neo4j_db_schema.jpg?raw=true "https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/neo4j_db_schema.jpg?raw=true")  

**Node labels**

| Node Labels | Description | Properties |
| :- | :------------- | :- |
| Screen | Screen of application. | <p> "path": "/WEB-INF/tiles/adm/Screen_414.jsp" <p>"fileName": "Screen_414.jsp" <p>"code": "Screen_414" <p>"documentation": "Screen ... <p>"name": "Screen_414" <p>"link": "ADM033" <p>"alias": "Title of Screen_414" <p> "id": "NEOID_cfabe9f8-ff6c-4ee6-ab19-ae0bdc7f192e" <p>"class": "ApplicationComponent" <p>"group": "ADM" |
| Fragment | Fragment bolongs to screen or other fragment. | <p>"path": "/tiles/com/fragments/Fragment_1297.jsp" <p>"fileName": "Fragment_1297.jsp" <p> "documentation": "Fragment ... " <p> "name": "Fragment_1297" <p> "id": "NEOID_0fdcc7a5-1889-4fb6-aa62-94bf5128f840" <p>"class": "ApplicationComponent" |
| File | File where screen or fragment is defined. | <p>"name": "Fragment_1315.jsp" <p>"path": "/tiles/com/fragments/Fragment_1315.jsp" <p>"id": "NEOID_04ff5f05-a207-4b8d-a1e8-928f187822e1" <p>"class": "DataObject" <p>"documentation": "File ..." |
| Role | Role that restricts access to screen.  | <p>"name": "Role_1259" <p>"id": "NEOID_44086a73-aa07-423e-a119-449e12e7ff9b" <p>"class": "DataObject" <p>"documentation": "Role ... " |

**Relationship Types**

| Relationship Types | Description |
| :- | :------------- |
| FlowRelationships | Relation represents the possible transition from one screen to another (name: 'LINK_TO'). |
| CompositionRelationships | Relation represents that fragment is part of the screen or another fragment (name: 'HAS_FRAGMENT'). |
| AssociationRelationships | Relation represents that screen or fragment is defined in the file (name: 'HAS_FILE'). Relation represents a role which controls access to the screen (name: 'HAS_ROLE'). |

## Description how to generate documentation
1. Create new Neo4j database (https://neo4j.com/sandbox/)
2. Set this Python script parameters:
    - boltUrl
    - password
    - exportPath
3. Run this script and generete files:
    - screen_model.xml
    - screens.csv
    - roles.csv
    - fragments.csv
    - links.csv
4. [Import](https://sparxsystems.com/enterprise_architect_user_guide/15.2/model_domains/imparchmeff.html "Import ArchiMate® 3.1 Model Exchange File") generated file [screen_model.xml](https://github.com/pospisilboh/ScreenDocumentation/blob/main/ExportFromNeo4j/screen_model.xml "File in format ArchiMate® 3.1 Model Exchange File definition") into a [prepared](https://github.com/pospisilboh/ScreenDocumentation/blob/main/EnterpriseArchitectModel/model_template.eapx "Prepared EA file with VB script") Enterprise Architect project as a UML model.
To import an Open Exchange Format file, in Ribbon select the item **"Specialize > Technologies > ArchiMate > Import Model Exchange File"**. Click on Import button to import the selected Model Exchange file into the specified Package.
5. Run a script in **Sparx Enterprise Architect**. To run the VB script, select context menu item "[Specialize->Scripts->#1 generate_archimate_diagrams](https://github.com/pospisilboh/ScreenDocumentation/blob/main/Image/ea_run_script.jpg "Run VB script")". Diagrams are generated by definition in files: 
    - screens.csv
    - roles.csv
    - fragments.csv
    - links.csv
