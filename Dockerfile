# original image: https://github.com/Cimpress-MCP/docker-git2consul
FROM alpine:3.2

LABEL git2consul-version="0.12.13"

RUN apk --update add nodejs git openssh ca-certificates && \
    rm -rf /var/cache/apk/* && \
    npm install git2consul@0.12.13 --global && \
    mkdir -p /etc/git2consul.d \
    mkdir /root/.ssh

# Using key for serv.GLPBuilder
# For bitbucket we need this else it wont authenticate with private repos
# We can perhaps move this to secrets & logic in entrypoint
# however we would need to decode the id_rsa in the container!
# NOTE: id_rsa is not checked in and added to .gitignore. Please have your own 
# id_rsa  
COPY id_rsa /root/.ssh/ 
COPY entrypoint.sh /


# URL to clone & Branch name is replaced in entrypoint
RUN ssh-keyscan bitbucket.pearson.com > /root/.ssh/known_hosts && \
    chmod 400 /root/.ssh/known_hosts && \
    chmod 400 /root/.ssh/id_rsa && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
