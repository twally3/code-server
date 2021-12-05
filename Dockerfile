FROM codercom/code-server:3.12.0

RUN sudo sed -i 's/<\/head>/<link type="text\/css" href="https:\/\/fonts.googleapis.com\/css2?family=Fira+Code:wght@300;400;500;600;700\&display=swap" rel="stylesheet"><\/head>/g' /usr/lib/code-server/src/browser/pages/vscode.html
RUN sudo sed -i 's/font-src/font-src fonts.gstatic.com/g' /usr/lib/code-server/src/browser/pages/vscode.html
RUN sudo sed -i 's/style-src/style-src fonts.googleapis.com/g' /usr/lib/code-server/src/browser/pages/vscode.html


COPY ./code-server/test.css test.css
RUN cp /usr/lib/code-server/src/browser/pages/vscode.html ./vscode.html
RUN sudo sed -i 's/<\/html>//g' ./vscode.html
RUN echo "<style>" >> ./vscode.html
RUN cat ./test.css >> ./vscode.html
RUN echo "</style>" >> ./vscode.html
RUN echo "</html>" >> ./vscode.html
RUN sudo mv ./vscode.html /usr/lib/code-server/src/browser/pages/vscode.html
RUN rm ./test.css

EXPOSE 8080
RUN ls /usr/lib/code-server/src/browser/pages
# This way, if someone sets $DOCKER_USER, docker-exec will still work as
# the uid will remain the same. note: only relevant if -u isn't passed to
# docker-run.
USER 1000
ENV USER=coder
WORKDIR /home/coder

# RUN /usr/bin/code-server --help

RUN /usr/bin/code-server --install-extension robbowen.synthwave-vscode
RUN /usr/bin/code-server --install-extension eamodio.gitlens

ENTRYPOINT ["/usr/bin/entrypoint.sh", "--link", "--bind-addr", "0.0.0.0:8080", "."]
