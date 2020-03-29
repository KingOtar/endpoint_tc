#!/bin/bash

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v terraform)" ]; then
  echo 'Error: terraform is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v git)" ]; then
  echo 'Error: git is not installed.' >&2
  exit 1
fi

if ! [ -x "$(command -v eb)" ]; then
  echo 'Error: eb is not installed.' >&2
  exit 1
fi

PROJECT=$(cd endpoint_challenge_tf; terraform output --json | jq .project_name.value -r)

## use codecommit helper to checkout repo
echo -e "Check out empty repo from AWS CodeCommit"
rm -rf $PROJECT
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git clone $(cd endpoint_challenge_tf; terraform output --json  | jq .clone_url_http.value -r;)

echo -e "Move files from build_filess into repo"
rsync -a --delete build_files/* $PROJECT

echo -e "Replace URL for ECR repo config for build steps"
ECR_URI=$(cd endpoint_challenge_tf; terraform output -json | jq .repository_url.value -r)
sed -i '' "s#%%IMAGE_REPO_URI%%#$ECR_URI#g" $PROJECT/buildspec.yml
echo "# $(date)" >> $PROJECT/buildspec.yml

cd $PROJECT
echo -e "Commit and initialize repo with build code"
git add .
git commit -m "initial repo"
git push origin master

echo -e

# Polling until build starts
COUNT=$(aws codebuild list-builds-for-project --project-name $PROJECT-package | jq '.ids | length')
POLLCOUNT=$COUNT

echo -e "Polling build"
while [[ $POLLCOUNT -le $COUNT ]]
do
	OUTPUT=$(aws codebuild list-builds-for-project --project-name $PROJECT-package)
	POLLCOUNT=$(echo $OUTPUT | jq '.ids | length')
	echo -e  ".\c"
done

LATEST=$(echo $OUTPUT | jq -r '.ids[0]')

echo $LATEST
echo -e "\n Waiting for build to finish"
BUILDSTATUS=""
while [[ "$BUILDSTATUS" != "SUCCEEDED" ]]
do
	BUILDSTATUS=$(aws codebuild batch-get-builds --ids $LATEST | jq .builds[0].buildStatus -r)
	echo -e ".\c"
done	

echo -e "Build is complete. Ready to deploy"
cd ..

rm deploy_files/Dockerrun.aws.json
cat <<EOT >> deploy_files/Dockerrun.aws.json
{
  "AWSEBDockerrunVersion": "1",
   "Image": {
    "Name": "$ECR_URI:latest",
    "Update": "true"
  },
  "Ports": [
    {
      "ContainerPort": "2368",
      "HostPOrt": "80"
    }
  ]
}
EOT

cd deploy_files
rm -rf .elasticbeanstalk
eb init
eb deploy 

echo -e "Complete"
echo -e
echo -e "URI: $(aws elasticbeanstalk describe-environments --environment-names $PROJECT-environment | jq .Environments[0].EndpointURL -r)"
