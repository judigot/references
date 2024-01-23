# Setup

- Allow local builds
    ```
    JAVA_OPTS=-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true
    ```
    Docker compose:
    
    ```yml
    environment:
      - JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true"

- Install NodeJS Plugin

        1. Go to Dashboard > Manage Jenkins > Manage Plugins > Available plugins

        2. Search for "NodeJS"

        3. Check the NodeJS Plugin by npm

        4. Click "Download now and install after restart"
        
        5. Check "Restart Jenkins when installation is complete and no jobs are running"
        
        6. After restart, go to Dashboard > Manage Jenkins > Global Tool Configuration
        
        7. Scroll down to NodeJS, then click Add NodeJS
        
        8. Set name to the version e.g. "18.0.0". This name will be used in the Jenkinsfile when building a pipeline.
                
                tools {
                    nodejs "18.0.0"
                }
                
        9. Select a version to insall, then click Save


# Restart Jenkins

Head to [localhost:8080/restart](http://localhost:8080/restart) to restart Jenkins
    

# CI/CD Pipeline

1. Create new item/job
2. Select Pipeline, then click OK
3. Scroll down to Pipeline. Use the settings below:

    Definition
      - Pipeline script from SCM
        - SCM
          - Git
          - Repository URL
            - **file:////var/jenkins_home/app/projectName**
            - **https://github.com/judigot/repository**
          - Branch Specifier (blank for 'any')
            - */main
        - Script Path
          - Jenkinsfile