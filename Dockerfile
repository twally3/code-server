FROM codercom/code-server:3.12.0

USER 1000
ENV USER=coder
WORKDIR /home/coder

# ADD FIRA CODE WITH LIGATURES
RUN sudo sed -i 's/<\/head>/<link type="text\/css" href="https:\/\/fonts.googleapis.com\/css2?family=Fira+Code:wght@300;400;500;600;700\&display=swap" rel="stylesheet"><\/head>/g' /usr/lib/code-server/src/browser/pages/vscode.html
RUN sudo sed -i 's/font-src/font-src fonts.gstatic.com/g' /usr/lib/code-server/src/browser/pages/vscode.html
RUN sudo sed -i 's/style-src/style-src fonts.googleapis.com/g' /usr/lib/code-server/src/browser/pages/vscode.html

# ADD NEON DREAMS CSS
COPY ./code-server/test.css test.css
RUN cp /usr/lib/code-server/src/browser/pages/vscode.html ./vscode.html
RUN sudo sed -i 's/<\/html>/<style>/g' ./vscode.html
RUN cat ./test.css >> ./vscode.html
RUN echo "</style></html>" >> ./vscode.html
RUN sudo mv ./vscode.html /usr/lib/code-server/src/browser/pages/vscode.html
RUN rm ./test.css

# # INSTALL NODEJS
ENV N_PREFIX=/home/coder/n
ENV PREFIX=$N_PREFIX
ENV PATH=$N_PREFIX/bin:$PATH
RUN sudo apt update
RUN sudo apt install make
RUN curl -L https://git.io/n-install -o install.sh
RUN chmod +x install.sh
RUN yes | ./install.sh
RUN rm install.sh

# INSTALL EXTENSIONS
RUN /usr/bin/code-server --install-extension robbowen.synthwave-vscode
RUN /usr/bin/code-server --install-extension eamodio.gitlens
RUN /usr/bin/code-server --install-extension octref.vetur
RUN /usr/bin/code-server --install-extension esbenp.prettier-vscode
RUN /usr/bin/code-server --install-extension dbaeumer.vscode-eslint
RUN /usr/bin/code-server --install-extension gruntfuggly.todo-tree
RUN /usr/bin/code-server --install-extension eg2.vscode-npm-script
RUN /usr/bin/code-server --install-extension mikestead.dotenv
RUN /usr/bin/code-server --install-extension wix.vscode-import-cost
RUN /usr/bin/code-server --install-extension kisstkondoros.vscode-codemetrics

EXPOSE 8080

ENTRYPOINT ["/usr/bin/entrypoint.sh", "--link", "--bind-addr", "0.0.0.0:8080", "."]
