FROM node:latest

ENV PORT=3000

ENV SERVER_URL=http://localhost:3000/api/v1

RUN apt-get update || : && apt-get install -y python build-essential

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

EXPOSE 3000

CMD [ "npm", "start"]