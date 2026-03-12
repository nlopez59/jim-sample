
This repo reflects my cumulative work in defining a complete Z DevOps demo environment across several specialized branches.

This branch, GHAv5 - My GitHub Action v5, is my main model where I've collected, documented and setup examples of features across our devops tools for learning, testing, product feedback and customer demos. 

As of Q2'2026, my stack includes these core products:
    - zOS 3.2 running under TAZ/ODE with CICS 63, DB2 13 and more See the stock image doc for the complete stack 
    - IDzEE v17 with, DBB ver 3.0.3, Wazi Deploy ver 3.0.6.1, ZCS? and Code Coverage ?
    
    
My supported feature list: 
  - TAZ/ODE - current stock is G0GTNML, with my customizations (ODT-Init Branch) to support many of the feature below.
  - A new frye template to spin up an ODE VM in 5 mins see zdevops_on_Frye branch 
  - VS Code IBM Exts with:
    - DBB User Build  - see the conf/build/readme for details     
    - TAZ/EDT         - record and play back batch and CICS pgm test cases      
    - OpenEd          - with support for Admins and Devs and specailed HLASM setup, advanced zapp.yaml features code coverage, zcs ...
    - Program Flow    - visually navigate a pgms logic flow and data elements (see 'Show in' context menu)
    - DeBug           - Run a debug session of batch, CICS pgms 
    - Code Coverage   - view the results of your test coverage with a special script to merge multiple reports in a unified view
    - DB2 Explorer    - navigate the DB2 catalog and run  SQL  - like SPUFI (not sure if and who formally supports it)
    - CICS Explorer   - navigate the CICS resource tables and run newcopy
    - zCodeScan       - with custom rules. Now supports rules in a central path (not tested yet)        
    - RCE             - 3270 access 
    - ... 
  
  - In GHA:
    - Wazi Deploy - With new samples to support for independent package and plan binds and access top JFROG
    - ZCS on agent for pipeline wit hooks to SQ
    - Code Coverage

    
