#!/usr/bin/env bash

if [ "$1" = "--restore-git" ] && [ -d ".git_back" ]
  then
    rm -rf .git
    mv .git_back .git
fi

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

echo
green_echo "Before we start"
echo
yellow_echo "Things you should do/have ready before starting to make the kickstart run smoothly ;)"
echo "  * think about your vendor and package name for the project"
echo "  * an empty git repo you want to push the project '${packageName}' to"
echo "  * a namespace ${vendorNameLowerCase}-${packageNameLowerCase}-staging already created in kubernetes"
echo "    (only relevant in the sandstorm context)"
echo
yellow_echo "Hit RETURN to provide your vendor and package name"
read -p ""
read -p "Vendor (default='$defaultVendorName'): " vendorName
vendorName=${vendorName:-$defaultVendorName}

read -p "Package (default='$defaultPackageName'): " packageName
packageName=${packageName:-$defaultPackageName}

vendorNameLowerCase=$(echo $vendorName | tr '[:upper:]' '[:lower:]')
packageNameLowerCase=$(echo $packageName | tr '[:upper:]' '[:lower:]')
echo

yellow_echo "This is what we will do next"
echo "  * we do a search replace on vendor und package names"
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
    git add .
    git commit -m "TASK: Neos Kickstart"

    read -p "Repo Url: " repoUrl

    if [ $repoUrl ]
      then
        git remote add origin $repoUrl
        git fetch
        git branch --set-upstream-to=origin/main main
        git pull --rebase
        if [ -f "README.md" ]
          then
            mv README.md README_CONFLICT.md
            mv PROJECT.md README.md
          else
            mv PROJECT.md README.md
        fi
        git add .
        git commit -m "TASK: Fixed possible README conflict"
        git push
    fi
  else
    yellow_echo "NO git repository was initialized."
fi
echo
green_echo "DONE"

