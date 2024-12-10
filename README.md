# rayab-web

🤖 🧶 Web interface using the rayab R package to create images ready to be knitted using the AYAB software 🤖 🧶 

Currently live at https://ayab.discourses.ch

## Build

### shinylive

You can use shinylive to bundle the shiny app developped in /app to a directory ready to be served from a static server. To build the app use:

```
shinylive::export("app", "site")
```

### Docker

To build a docker container with shiny server running the app use:

```
docker build -t <my-container> .
```

To run locally, run:

```
docker run -p 3000:3000 <my-container>
```

The site should now be live at http://127.0.0.1:3000

The latest image can also be pulled from https://hub.docker.com/r/marioangst/rayab-web

```
docker pull marioangst/rayab-web
```
