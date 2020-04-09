# Multi-phase docker compose for production 

# 1) Build phase
FROM node:alpine as builder
WORKDIR '/app'
# dependencies
COPY package.json .
RUN npm install
# copy source
COPY . .
# create the build folder
RUN npm run build
# no need for volumes here since won't change code here

# 2) run phase (new phase indicated by FROM)
# it dumps all previous phases, 
# so final image won't include node:alpine, source code, etc...
FROM nginx
# copy over build from a previous phase
COPY --from=builder /app/build /usr/share/nginx/html
# no need to specify start cmd; default nginx cmd will do