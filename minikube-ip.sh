#!/usr/bin/env bash
function error_exit() {
  echo "$1" 1>&2
  exit 1
}

function check_deps() {
  jq_test=$(which jq)
  if [[ -z $jq_test ]]; then error_exit "JQ binary not found"; fi
}

function extract_data() {
  my_ip=$(minikube ip)
  jq -n --arg my_ip "$my_ip" '{"my_ip":"'$my_ip'"}'
}

check_deps
extract_data