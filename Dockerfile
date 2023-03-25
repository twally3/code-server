FROM codercom/code-server:4.10.0
# https://github.com/coder/code-server/issues/1374

# ADD FIRA CODE WITH LIGATURES
RUN sudo sed -i 's/<\/head>/<link type="text\/css" href="https:\/\/fonts.googleapis.com\/css2?family=Fira+Code:wght@300;400;500;600;700\&display=swap" rel="stylesheet"><\/head>/g' /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html
RUN sudo sed -i 's/font-src/font-src fonts.gstatic.com/g' /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html
RUN sudo sed -i 's/style-src/style-src fonts.googleapis.com/g' /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html

RUN grep -rl "style-src 'self' 'unsafe-inline'" /usr/lib/code-server | sudo xargs sed -i "s/style-src 'self' 'unsafe-inline'/style-src 'self' 'unsafe-inline' fonts.googleapis.com/g"
RUN grep -rl "font-src 'self' blob:" /usr/lib/code-server | sudo xargs sed -i "s/font-src 'self' blob:/font-src 'self' blob: fonts.gstatic.com/g"

# ADD NEON DREAMS CSS
COPY ./code-server/test.css test.css
RUN cp /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html ./vscode.html
RUN sudo sed -i 's/<\/html>/<style>/g' ./vscode.html
RUN cat ./test.css >> ./vscode.html
RUN echo "</style></html>" >> ./vscode.html
RUN sudo mv ./vscode.html /usr/lib/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html
RUN rm ./test.css

# INSTALL NODEJS
ENV N_PREFIX=/home/coder/n
ENV PREFIX=$N_PREFIX
ENV PATH=$N_PREFIX/bin:$PATH
RUN sudo apt update
RUN sudo apt install make
RUN curl -L https://git.io/n-install -o install.sh
RUN chmod +x install.sh
RUN yes | ./install.sh
RUN rm install.sh

# INSTALL GO
RUN curl -fsSL https://raw.githubusercontent.com/twally3/g/master/install.sh | bash
RUN chmod +x g
RUN sudo mv g /usr/local/bin
RUN /usr/local/bin/g lts

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
RUN /usr/bin/code-server --install-extension golang.go

EXPOSE 8080
