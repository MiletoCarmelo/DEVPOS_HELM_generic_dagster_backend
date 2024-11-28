FROM python:3.11-slim
ARG DAGSTER_VERSION=1.6.0
ENV DAGSTER_HOME=/opt/dagster/dagster_home

# Création des répertoires nécessaires
RUN mkdir -p \
    $DAGSTER_HOME \
    $DAGSTER_HOME/history \
    $DAGSTER_HOME/schedules \
    $DAGSTER_HOME/compute_logs \
    /opt/dagster/app

# Copie des fichiers de configuration
COPY dagster.yaml $DAGSTER_HOME/
COPY app/repository.py /opt/dagster/app/

# Installation des packages
RUN pip install \
    dagster==${DAGSTER_VERSION} \
    dagster-azure \
    dagster-postgres \
    dagster-k8s \
    dagster-aws \
    dagster-celery[flower,redis,kubernetes] \
    dagster-celery-k8s \
    dagster-gcp \
    dagster-graphql \
    dagster-webserver

# Permissions
RUN chmod -R 777 $DAGSTER_HOME

# Commande de démarrage du webserver
CMD ["dagster-webserver", "-h", "0.0.0.0", "-p", "3000"]
EXPOSE 3000