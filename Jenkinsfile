#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

def prLabels = getPullRequestLabels {}

if ( prLabels.contains("test/integration") ) {
    def metricsApiHost

    stage('Trust') {
      enforceTrustedApproval('aerogear')
    }

    openshift.withCluster() {
        node ('jenkins-openshift') {
            stage ('Deploy app metrics service') {
            
                def repositoryName = "ios-sdk"
                def projectName = "test-${repositoryName}-${currentBuild.number}-${currentBuild.startTimeInMillis}"
                def metricsApiTemplatePath = "./ci/aerogear-app-metrics.yml"

                checkout scm

                openshift.newProject(projectName)
                openshift.withProject(projectName) {
                    openshift.newApp( "--file", "${metricsApiTemplatePath}" )
                    // Get URL of deployed metricsApi
                    def routeSelector = openshift.selector("route", "aerogear-app-metrics")
                    metricsApiHost = "http://" + routeSelector.object().spec.host
                }
            }
        }

        node ('osx') {
            stage('Cleanup osx workspace') {                    
                // Clean workspace
                deleteDir()
            }

            stage ('Checkout to osx slave') {
                checkout scm
            }

            stage ('Prepare config file') {
                def servicesConfigJsonPath = "./example/AeroGearSdkExample/mobile-services.json"
                // Update URL for metrics in mobile-services.json file
                def servicesConfigJson = readJSON file: servicesConfigJsonPath
                servicesConfigJson.services.each {
                    if ( it.id == "metrics" ) {
                        it.url = metricsApiHost + "/metrics"
                    }
                }
                writeJSON(file: servicesConfigJsonPath, json: servicesConfigJson)
            }

            stage ('Run integration test') {
                /**
                * Code for running integration test
                */
            }
        }

        openshift.delete("project", projectName)
    }
}