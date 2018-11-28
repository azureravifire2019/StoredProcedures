Redgate SQL Change Automation Jenkins Plugin
Introduction
The Redgate SQL Change Automation Plugin is an open-source plugin for using Redgate SQL Change Automation from within Jenkins. Four tasks are available:

Build your database from a Redgate SQL Change Automation or Redgate SQL Source Control project.
Test your database by running tSQLt tests.
Sync your database to another CI database.
Publish your database to a NuGet feed.
Installing
If you just want to use the plugin, follow these instructions:

Open your Jenkins.
Go to Manage Jenkins > Manage Plugins> Available and search for Redgate.
Tick the Redgate SQL Change Automation Plugin, and click 'Install Without Restart'
How to build/debug the plugin.
A basic tutorial for developing plugins is at https://wiki.jenkins-ci.org/display/JENKINS/Plugin+tutorial.

Simply:

Clone this repository.
Install Maven.
Open a command prompt at the repository root directory. Then run:
set MAVEN_OPTS=-Xdebug -Xrunjdwp:transport=dt_socket,server=y,address=8000,suspend=n
mvn hpi:run A development copy of Jenkins starts-up with the Redgate SQL Change Automation plugin loaded.
JetBrains IntelliJ IDEA is a good environment for developing and debugging Jenkins plugins. There is a free community edition.

"I've got an idea for an improvement"
Great! Code it up and submit a pull request. If it looks good, we'll merge it in.

Alternatively, email us at support@red-gate.com. We're always keen to hear your ideas and how you're using our tools.
