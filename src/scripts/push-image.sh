#!/bin/bash 

IFS="," read -ra DOCKER_TAGS <<< "$ORB_EVAL_TAG"
PROJECT_ID="${!ORB_ENV_PROJECT_ID}"

for tag_to_eval in "${DOCKER_TAGS[@]}"; do
    TAG=$(eval echo "$tag_to_eval")
    if [[ "$ORB_VAL_REGISTRY_URL" == *"docker.pkg.dev" ]]; then
        docker push "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_IMAGE:$TAG"
    else
        docker push "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_REPOSITORY_NAME/$ORB_VAL_IMAGE:$TAG"
    fi
done

if [ -n "$ORB_VAL_DIGEST_PATH" ]; then
    mkdir -p "$(dirname "$ORB_VAL_DIGEST_PATH")"
    SAMPLE_FIRST=$(eval echo "${DOCKER_TAGS[0]}")
    if [[ "$ORB_VAL_REGISTRY_URL" == *"docker.pkg.dev" ]]; then
        docker image inspect --format="{{index .RepoDigests 0}}" "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_IMAGE:$SAMPLE_FIRST" > "$ORB_VAL_DIGEST_PATH"
    else
        docker image inspect --format="{{index .RepoDigests 0}}" "$ORB_VAL_REGISTRY_URL/$PROJECT_ID/$ORB_VAL_REPOSITORY_NAME/$ORB_VAL_IMAGE:$SAMPLE_FIRST" > "$ORB_VAL_DIGEST_PATH"
    fi 
fi
