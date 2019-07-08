podTemplate(name: 'jenkins-jnlp', cloud: 'kubernetes',
  namespace: 'kube-ops', label: 'jenkins-jnlp',
  serviceAccount: 'jenkins2', containers: [
  containerTemplate(
      name: 'xyjnlp',
      image: 'zhaoxy8/jenkins-slave-docker:dev-ed14a9a',
      workspace: '/home/jenkins',
      //args: '${computer.jnlpmac} ${computer.name}',
      ttyEnabled: true,
      privileged: false,
      alwaysPullImage: false)
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
    hostPathVolume(mountPath: '/home/jenkins/.kube', hostPath: '/root/.kube')
  ]
){
node('jenkins-jnlp') {
    stage('Prepare') {
    	container('xyjnlp') {
        echo "1.Prepare Stage"
	sleep 300
        checkout scm
        script {
            build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()
            if (env.BRANCH_NAME != 'master') {
                build_tag = "${env.BRANCH_NAME}-${build_tag}"
            }
        }
      }
    }
    stage('Test') {
      echo "2.Test Stage"
    }
    stage('Build') {
        echo "3.Build Docker Image Stage"
        sh "docker build -t zhaoxy8/jenkins-slave-docker:${build_tag} ."
    }
    stage('Push') {
        echo "4.Push Docker Image Stage"
        withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sh "docker login -u ${dockerHubUser} -p ${dockerHubPassword}"
            sh "docker push zhaoxy8/jenkins-slave-docker:${build_tag}"
        }
    }
    stage('Deploy') {
        echo "5. Deploy Stage"
        if (env.BRANCH_NAME == 'master') {
            input "确认要部署线上环境吗？"
        }
    }
}
}
