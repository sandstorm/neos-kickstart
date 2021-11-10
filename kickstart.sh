#!/usr/bin/env bash

green_echo() {
  printf "\033[0;32m%s\033[0m\n" "${1}"
}
yellow_echo() {
  printf "\033[1;33m%s\033[0m\n" "${1}"
}
red_echo() {
  printf "\033[0;31m%s\033[0m\n" "${1}"
}
grey_echo() {
  printf "\033[0;37m%s\033[0m\n" "${1}"
}

if [ "$1" = "--restore-git" ]
  then
    if [ -d ".git_back" ]
      then
        yellow_echo "Found folder .git_back, restoring ..."
        rm -rf .git
        mv .git_back .git
      else
        red_echo "No folder .git_back present, nothing to restore."
    fi
    exit 0
fi

initNewGitRepo="no"

findExcludePaths=""
findExcludePaths="${findExcludePaths} -not -name kickstart.sh"
findExcludePaths="${findExcludePaths} -not -path */node_modules/*"
findExcludePaths="${findExcludePaths} -not -path */.idea/*"
findExcludePaths="${findExcludePaths} -not -path */.git/*"

defaultVendorName="MyVendor"
defaultPackageName="AwesomeNeosProject"

defaultVendorNameLowerCase=$(echo $defaultVendorName | tr '[:upper:]' '[:lower:]')
defaultPackageNameLowerCase=$(echo $defaultPackageName | tr '[:upper:]' '[:lower:]')

defaultDockerHubPath="infrastructure/neos-on-docker-kickstart"

green_echo "Please Provide the following information"
read -p "Vendor (default='$defaultVendorName'): " vendorName
vendorName=${vendorName:-$defaultVendorName}

read -p "Package (default='$defaultPackageName'): " packageName
packageName=${packageName:-$defaultPackageName}

vendorNameLowerCase=$(echo $vendorName | tr '[:upper:]' '[:lower:]')
packageNameLowerCase=$(echo $packageName | tr '[:upper:]' '[:lower:]')

echo
green_echo "Before we start"
echo
yellow_echo "Things you should have already set up to make the kickstart run smoothly ;)"
echo "  * an empty git repo you want to push the project '${packageName}' to"
echo "  * the namespace '${vendorNameLowerCase}-${packageNameLowerCase}-staging' already created in kubernetes"
echo "    (only relevant in the sandstorm context)"
echo
yellow_echo "Hit RETURN to continue, or CTRL+C to exit"
read -p ""

yellow_echo "This is what we will do next"
echo "  * we do a search replace on vendor and package names"
echo "     * e.g. Flow packages names will be renamed to '${vendorName}.${packageName}'"
echo "     * e.g. the composer packageName will be renamed to '${vendorNameLowerCase}/${packageNameLowerCase}'"
echo "     * ..."
echo "  * we will switch around READMEs to provide you with a good default"
echo "    for documenting your project"
echo "  * we remove some kickstarter files"
echo "  * you will later be asked if you want to init a new .git with a new remote"
echo

yellow_echo "Hit RETURN to start replacing, or CTRL+C to exit"
read -p ""

# rename distribution package
mv ./app/DistributionPackages/${defaultVendorName}.${defaultPackageName} ./app/DistributionPackages/${vendorName}.${packageName} 2> /dev/null

yellow_echo "Replacing Name of Vendor ..."
yellow_echo "Replacing Name of Package ..."

# replace Vendor and Package name -> yaml, php, package.json ...
find ./ -type f ${findExcludePaths} -exec grep -Iq . {} \; -print | xargs sed -i '' "s/${defaultVendorName}/${vendorName}/g"
find ./ -type f ${findExcludePaths} -exec grep -Iq . {} \; -print | xargs sed -i '' "s/${defaultPackageName}/${packageName}/g"

find ./ -type f ${findExcludePaths} -exec grep -Iq . {} \; -print | xargs sed -i '' "s/${defaultVendorNameLowerCase}/${vendorNameLowerCase}/g"
find ./ -type f ${findExcludePaths} -exec grep -Iq . {} \; -print | xargs sed -i '' "s/${defaultPackageNameLowerCase}/${packageNameLowerCase}/g"

yellow_echo "Moving README files ..."
mv ./README.md ./KICKSTART.md
mv ./PROJECT.md ./README.md


yellow_echo "Removing Kickstart files ..."

if [ "$1" != "--dev" ]
  then
    rm ./kickstart.sh
fi
echo
yellow_echo "The kickstart has finished. Should we init a new git repository for you?"
red_echo "This will remove the .git folder and run 'git init'!!!"
red_echo "If you are unsure you can do it later manually."
read -p "Init new repo 'yes/no' (default=$initNewGitRepo): " initNewGitRepo
initNewGitRepo=${initNewGitRepo:-"no"}
echo

if [ "$initNewGitRepo" = "yes" ]
  then
    yellow_echo "Backing up .git"
    mv .git .git_back
    rm -rf .git

    git init -b main

    read -p "Repo Url: " repoUrl

    if [ $repoUrl ]
      # we have move the README to prevent conflicts with an initialized git repo
      # which usually has an empty README
      mv ./README.md ./README_PROJECT.md
      then
        if [[ $repoUrl == *"gitlab.sandstorm.de"* ]]; then
          yellow_echo "Sandstorm Gitlab repo detected ;)"
          repoPath=$(echo $repoUrl | sed -e 's;ssh://git@gitlab.sandstorm.de:29418/;;g' -e 's;.git;;g')
          yellow_echo "Replacing path to dockerhub in app.yaml with $repoPath"
          sed -i '' "s;${defaultDockerHubPath};${repoPath};g" deployment/staging/app.yaml
        fi

        git add .
        git commit -m "TASK: Neos Kickstart"

        git remote add origin $repoUrl
        echo "Touch your YubiKey"
        git fetch
        git branch --set-upstream-to=origin/main main
        git pull --rebase
        if [ -f "README.md" ]
          then
            mv README.md README_CONFLICT.md
        fi
        # move back project documentation README template provided with the kickstarter package ;)
        mv README_PROJECT.md README.md
        git add .
        git commit -m "TASK: Fixed possible README conflict"
        git push
    fi
  else
    yellow_echo "NO git repository was initialized."
fi
echo
green_echo "DONE - Check README.md again to start developing your Neos project."

