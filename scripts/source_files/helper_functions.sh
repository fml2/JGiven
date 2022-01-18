#!/usr/bin/env bash

#Update the version property in a gradle properties file
function update_version(){
  [ $# -eq 2 ] || return 11
  local target_version="$1"
  local target_file="$2"
  local version_property="version"
  local version_matcher="${version_property}=.*"
  if grep -E "${version_matcher}" "${target_file}" ;then
    sed -i -e "s/${version_matcher}/${version_property}=${target_version}/" "${target_file}" || return 12
  else
    printf "Could not find version property to replace in file %s\n" "${target_file}"
    return 13
  fi
  return 0
}

#Update the version property in an sbt file, which requires the version to be quoted
function update_scala_version() {
  [ $# -eq 2 ] || return 21
  local target_version="$1"
  local target_file="$2"
  local version_property="jgivenVersion"
  local version_matcher="${version_property} = .*"
  if grep -E "${version_matcher}" "${target_file}" ;then
    sed -i -e "s/${version_matcher}/${version_property} = \"${target_version}\"/" "${target_file}" || return 22
  else
    printf "Could not find version property to replace in file %s\n" "${target_file}"
    return 23
  fi
  return 0
}

function updateAllVersionInformation() {
  [ $# -eq 1 ] || return 31
  local VERSION="$1"

  echo Updating version in gradle.properties...
  for file in "gradle.properties" \
  "example-projects/junit5/gradle.properties" \
  "example-projects/spock/gradle.properties" \
  "example-projects/testng/gradle.properties" \
  "example-projects/android/gradle.properties" \
  "example-projects/kotlin/gradle.properties" \
  "example-projects/selenium/gradle.properties" \
  "example-projects/spring-boot/gradle.properties"
  do
    update_version "${VERSION}" "${file}" || exit $?
  done

  update_scala_version "${VERSION}" "example-projects/scala/build.sbt" || exit $?
}

function runGradleTestOnGivenProject() {
    [ $# -eq 2 ] || return 41
    local givenProject="$1"
    local VERSION="$2"

    ./gradlew -b $givenProject clean test -Pversion=$VERSION
}

function runScalaTest() {
    pushd example-projects/scala > /dev/null
    sbt test jgivenReport
    popd  > /dev/null
}

function runAndroidTestOnGivenProject() {
    [ $# -eq 2 ] || return 51
    local givenProject="$1"
    local VERSION="$2"

    ./gradlew -b $givenProject clean test connectedAndroidTest -Pversion=$VERSION
}

function runMavenTestOnGivenProject() {
    [ $# -eq 2 ] || return 61
    local givenProject="$1"
    local VERSION="$2"

    mvn -U -f $givenProject clean test -Djgiven.version=$VERSION
}