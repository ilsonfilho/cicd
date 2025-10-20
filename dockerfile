# ----------------------------------------------------------------------
# STAGE 1: Build (Ambiente para instalação de dependências)
# ----------------------------------------------------------------------
FROM node:18-alpine AS builder

WORKDIR /app

# 1. Copia apenas os ficheiros de dependência
COPY package*.json ./ 
# Se estiver usando pnpm:
# COPY pnpm-lock.yaml ./

# 2. Copia o código-fonte restante
COPY . .  
# NOTA: O .dockerignore deve ignorar node_modules, logs, .git, etc.

# 3. Instala as dependências de produção
RUN npm install --production=true

# ----------------------------------------------------------------------
# STAGE 2: Production (Imagem Final)
# ----------------------------------------------------------------------
FROM node:18-alpine

# Cria um usuário não-root (boa prática de segurança)
RUN addgroup --gid 1001 appuser && \
    adduser --uid 1001 --ingroup appuser --shell /bin/false --disabled-password --gecos "" appuser

WORKDIR /app

# Copia TUDO do diretório /app da imagem 'builder' para o diretório /app desta imagem.
# Agora, o /app no builder contém: package.json, index.js, node_modules.
COPY --from=builder /app ./

# Define a porta de escuta
EXPOSE 3000

# Executa como o usuário não-root
USER appuser

# Executa o comando de produção.
CMD [ "npm", "start" ]