# Release Scripts for Enonic

The release scripts will build, tag and push the required changes to Git repo. 

## Release Maven projects

To release maven projects, check out the latest scripts and run the following:

	release_maven.sh <project> <branch> <release_version> <next_version>
	
Example for releasing cms-shell:

	release_maven.sh cms-shell master 1.2.0 1.2.0-SNAPSHOT

## Release Gradle projects

To release gradle projects, check out the latest scripts and run the following:

	release_grale.sh <project> <branch> <release_version> <next_version>
	
Example for releasing cms-shell:

	release_grale.sh cms-shell master 1.2.0 1.2.0-SNAPSHOT
	