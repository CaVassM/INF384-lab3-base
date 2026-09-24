# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

FROM public.ecr.aws/lambda/nodejs:20 AS build

WORKDIR /app

COPY package.json package-lock.json ./


RUN npm ci

# Construccion
COPY src ./src
RUN npm run build && npm prune --omit=dev

FROM public.ecr.aws/lambda/nodejs:20 AS runtime
ENV NODE_ENV=production

COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

CMD ["src/handler.handler"]
