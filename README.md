# rayab-web

🤖 🧶 Web interface using the rayab R package to create images ready to be knitted using the AYAB software 🤖 🧶 

The web application can use shinylive to convert a shiny app developped in /app to serve from a static server.

To build the app use:

```
shinylive::export("app", "site")
```

To build a docker container with shiny server running the app use:

```
# Build
docker build -t marioangst/rayab-web .

# Test, visit http://127.0.0.1:3000
docker run -p 3000:3000 marioangst/rayab-web

# Push
docker push marioangst/rayab-web
```