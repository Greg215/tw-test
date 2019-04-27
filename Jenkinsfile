#!groovy

env.DOCKER_TAG = BUILD_TAG.toLowerCase()

if(currentBuild.getPreviousBuild()){
  env.PREVIOUS_BUILD_RESULT = currentBuild.getPreviousBuild().getResult()
  echo "PREVIOUS BUILD RESULT: ${env.PREVIOUS_BUILD_RESULT}"
  } else {
    env.PREVIOUS_BUILD_RESULT = "NONE"
  }

  String getChangeSet(String input){
    def var1 = sh(script: "git whatchanged -n 1  | cut -f2 | grep '^${input}' | wc -l", returnStdout: true).trim()
    var1
  }

  int getChangeSetOnLocalFolder(String input){
    def var1 = sh(script: "find ${input} 2>/dev/null | wc -l", returnStdout: true).trim()
    var1.toInteger()
  }

void executeMakeStep(String makeStep, int size ){
    echo makeStep
    if (size > 0 || env.PREVIOUS_BUILD_RESULT=="FAILURE") {
      sh  'make -s ' + makeStep
      }else{
        echo 'nothing to execute because there are no changes'
      }
}

def waitForUserInput(String message, String choices, int duration, String defaultChoice){
    def userInput = defaultChoice
      try{
          timeout(time: duration, unit: 'SECONDS') {
            userInput = input message: message, ok: 'OK',
            parameters: [choice(name: 'USERINPUT', choices: choices, defaultChoice: defaultChoice, description: message)]
          }
          } catch (err) {
            userInput = defaultChoice
          }
          userInput
}

node{
  properties([disableConcurrentBuilds()])
  ansiColor('xterm') {

    stage('Checkout') {
      checkout scm
    }

    stage('Cleanup') {
      echo "Cleanup"
      sh 'rm -rf target/'
      def value = 'jenkins-' + env.JOB_NAME
      def s = value.replaceAll('/','-')
      env.IMAGES_TAG = s.toLowerCase()
      echo env.IMAGES_TAG
      executeMakeStep('cleanupImages', 1)
    }

   stage ('Select to create a new Dev env or use locally') {
     def envType = waitForUserInput('Create new Environment or deploy locally ', "Deploy Locally" + "\nCreate New Env" + "\nNone", 60, 'none')
	if(envType == 'Deploy Locally') {
		  
		  stage ('Build DEV environment in docker') {
                    def userInput = waitForUserInput('Build new Dev Env ? ', 'no\nyes', 60, 'no')
		    if (userInput.contains("yes")){
		          echo "Buile a new Dev Environment."
		          executeMakeStep('buildByAnsible', 1)
	  	    } else {
			  echo "Will not create new dev environment."
		    }
		   }

	 	  stage ('Deploy Locally') {
		    def userInput = waitForUserInput('Deploy artifacts ? ', 'no\nyes', 60, 'no')		
		    if (userInput.contains("yes")){
                          echo "Deploy artifacts."
		    	  executeMakeStep('deployByAnsible', 1)
	 	    } else {
  			  echo "Will not deploy artifacts."
		    }
	 	  }

	} else if (envType == 'Create New Env') {
		echo "Function not defined yet, and no other envs available yet!"
	 
	} else {
		echo "No environment selected"
	}
    }
  }
}
 
