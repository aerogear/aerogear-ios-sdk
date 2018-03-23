#!groovy

// https://github.com/feedhenry/fh-pipeline-library
@Library('fh-pipeline-library') _

stage('Trust') {
    enforceTrustedApproval('aerogear')
}

def prLabels = getPullRequestLabels {}


def runIntegrationTest() {
  def repositoryName = "ios-sdk"
  def projectName = "test-${repositoryName}-${currentBuild.number}-${currentBuild.startTimeInMillis}"
  def metricsApiTemplatePath = "./ci/aerogear-app-metrics.yml"
  
    openshift.withCluster() {
      openshift.newProject(projectName)
      openshift.withProject(projectName) {
          openshift.newApp( "--file", "${metricsApiTemplatePath}" )
          // Get URL of deployed metricsApi
          def routeSelector = openshift.selector("route", "aerogear-app-metrics")
          def metricsApiHost = "http://" + routeSelector.object().spec.host
          def servicesConfigJsonPath = "./example/AeroGearSdkExample/mobile-services.json"
          // Update URL for metrics in mobile-services.json file
          def servicesConfigJson = readJSON file: servicesConfigJsonPath
          servicesConfigJson.services.each {
            if ( it.id == "metrics" ) {
              it.url = metricsApiHost + "/metrics"
            }
          }
          writeJSON(file: servicesConfigJsonPath, json: servicesConfigJson)
          /**
           * Run integration test here
           */
          openshift.delete("project", projectName)
      }
    }
}
 
node('osx') {
    stage("Checkout") {
      checkout scm
    }
    stage('Preparation') {                    
        // Clean workspace
        deleteDir()
    }

    stage('Install cocoapods') {
        env.SCAN_DEVICE="iPhone 6"
        env.SCAN_SCHEME="AeroGearSdkExample"
        sh 'pod setup'
        dir('example') {
            sh 'pod install'
            sh 'fastlane scan'
        }
    }
    
    if ( prLabels.contains("integration test") ) {
      stage ("Integration test") {
        runIntegrationTest()
      }
    }
}
