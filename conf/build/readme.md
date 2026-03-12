The folder reflects the central admin configuration for dbb builds With my personal customizations and workflow

Currently supported and tested features within this configuration (Q2-2026) include:

 - Basic product samples yamls to build cobol, asm, pli pgms with and without cics and db2 (IMS support is not included iun this sample repo)
 - Includes sample code to Bind and Newcopy within a VS Code User build 
 - Advanced  scripting to support plan binds in Wazi Deploy using a new DBB deploytype  DBRMP
 -  As of DBB 3.0.3, modelled the new "Language configuration override" feature to support build options overrides. The Concept in order of percedence: 
        - defaults that are hard coded in the lang yaml files 
        - global overrides to defaults using non-restricted dbb-app.yaml options         
        - group overrides in the dbb-app-yaml create a new var using forfiles and assign a process_group like reference
            - the reference is in ...  
        - pgm level overrides:
            - Add a new config folder the the repo link  repo/source/config ??? 
            - create a pgm.ext.yaml config override file for the pgm
        
    - Sample code: 
            - source/.dbb_processor and dbb-app.build
            
    - Ref: 
        - https://www.ibm.com/docs/en/adffz/dbb/3.0.x?topic=overview-what-is-new-noteworthy#important-notices-2
        - https://www.ibm.com/docs/en/adffz/dbb/3.0.x?topic=index-task-language#languageconfigurationsource
            



other Highlights: 
    - DBB V3.04 - Q1'26 now support a package step to prep artifacts for WD - dont need WD pyton util (Not integrated) 

more to come ..
