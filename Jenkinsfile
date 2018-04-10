#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

def prLabels = getPullRequestLabels {}

if ( prLabels.contains("test/integration") ) {
    def metricsApiHost
    def repositoryName = "ios-sdk"
    def projectName = "test-${repositoryName}-${currentBuild.number}-${currentBuild.startTimeInMillis}"
    def linkToApiMetricsTemplate = "https://raw.githubusercontent.com/aerogear/aerogear-app-metrics/master/openshift-template.yml"
    def apiMetricsTemplateFilename = "api-metrics-template.yml"

    stage('Trust') {
      enforceTrustedApproval('aerogear')
    }

    openshift.withCluster() {
        node ('jenkins-openshift') {
            stage ('Deploy app metrics service') {

                sh "curl ${linkToApiMetricsTemplate} > ${apiMetricsTemplateFilename}"

                openshift.newProject(projectName)
                openshift.withProject(projectName) {
                    def routeSelector

                    openshift.newApp( "--file", "${apiMetricsTemplateFilename}" )
                    // Get URL of deployed metricsApi
                    routeSelector = openshift.selector("route", "aerogear-app-metrics")
                    metricsApiHost = "https://" + routeSelector.object().spec.host
                }
            }

            try {

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
                        def servicesConfigJson = readJSON file: servicesConfigJsonPath

                        // Update URL for metrics in mobile-services.json file
                        servicesConfigJson.services.each {
                            if ( it.id == "metrics" ) {
                                it.url = metricsApiHost + "/metrics"
                            }
                        }
                        writeJSON(file: servicesConfigJsonPath, json: servicesConfigJson)
                    }

                    stage ('Run integration test') {
                        sh "pod setup"
                        dir('example') {
                            sh """
                            pod install
                            xcodebuild \
                            -workspace AeroGearSdkExample.xcworkspace \
                            -scheme AeroGearSdkExampleTests \
                            -sdk iphonesimulator \
                            -destination 'platform=iOS Simulator,name=iPhone 7' \
                            '-only-testing:AeroGearSdkExampleTests/MetricsIntegrationTests' \
                            test \
                            CODE_SIGNING_REQUIRED=NO
                            """
                        }
                    }
                }
            } catch (Exception e) {
                println("Integration test failed with exception: ${e} \nDeleting OpenShift App Metrics project...")
            } finally {
                openshift.delete("project", projectName)
            }
        }
    }
}
