{{/*
Expand the name of the chart.
*/}}
{{- define "transact.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "transact.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 59 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 59 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 59 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}


{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "transact.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/*
Selector labels
*/}}
{{- define "app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transact.name" . }}{{ "-app" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "web.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transact.name" . }}{{ "-web" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transact.name" . }}{{ "-api" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "iso.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transact.name" . }}{{ "-iso" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "logstash.selectorLabels" -}}
app.kubernetes.io/name: {{ include "transact.name" . }}{{ "-logstash" }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{- define "app.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.app.repository }}{{ ":" }}
{{- if .Values.appVersion }}
{{- .Values.appVersion }}{{ "." }}
{{- end }}
{{- .Values.image.app.tag }}
{{- end }}

{{- define "web.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.web.repository }}{{ ":" }}
{{- if .Values.appVersion }}
{{- .Values.appVersion }}{{ "." }}
{{- end }}
{{- .Values.image.web.tag }}
{{- end }}

{{- define "iso.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.iso.repository }}{{ ":" }}
{{- default .Values.appVersion }}{{ "." }}
{{- .Values.image.iso.tag }}
{{- end }}

{{- define "api.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.api.repository }}{{ ":" }}
{{- if .Values.appVersion }}
{{- .Values.appVersion }}{{ "." }}
{{- end }}
{{- .Values.image.api.tag }}
{{- end }}

{{- define "logs.image"}}
{{- if .Values.image.registry }}
{{- .Values.image.registry | trimSuffix "/" }}{{ "/" }}
{{- end }}
{{- .Values.image.logstash.repository }}{{ ":" }}
{{- .Values.image.logstash.tag }}
{{- end }}

{{/*
Database connection string based on DB Type
*/}}
{{- define "database.connectionstring" }}
{{- if eq .Values.database.type "AzureSQL" }}
{{- "jdbc:sqlserver://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 1433 }}{{ ";" }}
{{- "databaseName=" }}{{ .Values.database.database | default "transact" -}}{{ ";" }}
{{- "integratedSecurity=false" }}
{{- end }}
{{- if eq .Values.database.type "NuoDB" }}
{{- "jdbc:com.nuodb://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 48004 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ "?" }}
{{- "SCHEMA=USER" }}
{{- end }}
{{- if eq .Values.database.type "PostgreSQL" }}
{{- "jdbc:postgresql://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 5432 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ "?" }}
{{- "idle_in_transaction_session_timeout=2000&tcpKeepAlive=true&cleanupSavepoints=true" }}
{{- end }}
{{- if eq .Values.database.type "PostgreSQLawsWrapper" }}
{{- "jdbc:aws-wrapper:postgresql://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 5432 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ "?" }}
{{- "wrapperPlugins=iam&user=" }}{{ .Values.database.user }}{{ "&iamDefaultPort=5432" }}{{ "&idle_in_transaction_session_timeout=2000&tcpKeepAlive=true&cleanupSavepoints=true" }}
{{- end }}
{{- if eq .Values.database.type "Yugabyte" }}
{{- "jdbc:yugabyte://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 5432 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ .Values.database.options }}
{{- end }}
{{- if eq .Values.database.type "Oracle" }}
{{- "jdbc:oracle://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 1521 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ ";" }}
{{- end }}
{{- end }}


{{/*
Active MQ connection string
*/}}
{{- define "mq.connectionstring" }}{{ .Values.mq.connectionstring }}{{- end }}

{{/*
App service account name
*/}}
{{- define "serviceaccount.app.name" -}}
{{- if .Values.serviceAccount.app -}}
{{ .Values.serviceAccount.app }}
{{- else -}}
{{ template "transact.fullname" . }}{{ "-app-sa" }}
{{- end -}}
{{- end -}}

{{/*
Web service account name
*/}}
{{- define "serviceaccount.web.name" -}}
{{- if .Values.serviceAccount.web -}}
{{ .Values.serviceAccount.web }}  
{{- else -}}
{{ template "transact.fullname" . }}{{ "-web-sa" }}
{{- end -}}
{{- end -}}

{{/*
API service account name
*/}}
{{- define "serviceaccount.api.name" -}}
{{- if .Values.serviceAccount.api -}}
{{ .Values.serviceAccount.api }}  
{{- else -}}
{{ template "transact.fullname" . }}{{ "-api-sa" }}
{{- end -}}
{{- end -}}

{{/*
JAVA_OPTS for APP
*/}}
{{- define "java.opts.app" }}
{{- if eq .Values.database.type "AzureSQL" }}
{{- if not .Values.deployTE.enabled  }}
{{- "-Dresource.server.options.tenant.jdbc.url.1='"}}
{{- "jdbc:sqlserver://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 1433 }}{{ ";" }}
{{- "databaseName=" }}{{ .Values.database.database | default "transact" -}}{{ ";" }}
{{- "integratedSecurity=false'" }}
{{- "-Dresource.server.options.tenant.jdbc.username.1=" | indent 1 }}
{{- .Values.database.user }}
{{- "-Dresource.server.options.tenant.jdbc.password.1=" | indent 1 }}
{{- .Values.database.encryptedPassword }}
{{- end }}
{{- end }}
{{- if eq .Values.database.type "PostgreSQL" }}
{{- if not .Values.deployTE.enabled  }}
{{- "-Dresource.server.options.tenant.jdbc.url.1=" }}"{{- "jdbc:postgresql://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 5432 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ .Values.database.options }}"
{{- "-Dresource.server.options.tenant.jdbc.username.1=" | indent 1 }}
{{- .Values.database.user }}
{{- "-Dresource.server.options.tenant.jdbc.password.1=" | indent 1 }}
{{- .Values.database.encryptedPassword }}
{{- end }}
{{- end }}
{{- if eq .Values.database.type "PostgreSQLawsWrapper" }}
{{- if not .Values.deployTE.enabled  }} 
{{- "-Dresource.server.options.tenant.jdbc.url.1=" }}"{{- "jdbc:aws-wrapper:postgresql://" }}
{{- .Values.database.host }}{{ ":" }}{{ .Values.database.port | default 5432 }}{{ "/" }}
{{- .Values.database.database | default "transact" -}}{{ "?" }}
{{- "wrapperPlugins=iam&user=" }}{{ .Values.database.user }}{{- "&idle_in_transaction_session_timeout=2000&tcpKeepAlive=true&cleanupSavepoints=true" }}"
{{- end }}
{{- "-Dtemn.tafj.jdbc.driver=software.amazon.jdbc.Driver"| indent 1 }}
{{- end }}
{{- if .Values.redis.enabled }} 
{{- "-Dtemn.cache.host="| indent 1 }}
{{- .Values.redis.host }}
{{- "-Dtemn.cache.port=6379"| indent 1 }}
{{- "-Dtemn.cache.provider=REDIS"| indent 1 }}
{{- "-Dtemn.cache.password="| indent 1 }}
{{- .Values.redis.keys }}
{{- end }}
{{- if eq .Values.environment "aks" }}
{{- "-Dmda.registry.url=https://"| indent 1 }}
{{- .Values.config.name }}{{"genericconfigapp.azurewebsites.net/api/v2.0.0/system/configurationGroups/{}/configuration/{}"}}
{{- "-Dtemn.msf.stream.kafka.bootstrap.servers="| indent 1 }}
{{- .Values.config.name }}{{"coreeventhub.servicebus.windows.net:9093"}}
{{- end }}
{{- "-Dbrowser.options.fullExternalCommandAccess=\"Y\""| indent 1 }}
{{- if eq .Values.temnmonitor.enabled true }}
{{- "-Dtemn.meter.exporter.host=" | indent 1}}
{{- .Values.meter.host }}
{{- "-Dtemn.meter.exporter.port=" | indent 1}}
{{- .Values.meter.port }}
{{- "-Dtemn.meter.enable.jmx=" | indent 1}}
{{- .Values.meter.jmx }}
{{- "-Dtemn.meter.disabled=false" | indent 1}}
{{- "-Dtemn.tracer.host=" | indent 1}}
{{- .Values.tracer.host }}
{{- "-Dtemn.tracer.port=" | indent 1}}
{{- .Values.tracer.port }}
{{- "-Dtemn.tracer.runtime=" | indent 1}}
{{- .Values.tracer.runtime }}
{{- "-Dtemn.tracer.disabled=false" | indent 1}}
{{- else }}
{{- "-Dtemn.tafj.runtime.enable.jbc.meter=false -Dtemn.tafj.runtime.enable.tafj.meter=false" | indent 1 }}
{{- "-Dtemn.tafj.runtime.enable.jbc.tracer=false -Dtemn.tafj.runtime.enable.tafj.tracer=false" | indent 1 }}
{{- end }}
{{- "-Dclass.outbox.dao=com.temenos.inboxoutbox.data.sql.OutboxDaoImpl"| indent 1 }}
{{- "-Doutboxid.jms.queue.name=java:/queue/tafj-outboxIdQueue"| indent 1 }}
{{- "-Doutboxid.jms.connection.factory=java:/JmsXA"| indent 1 }}
{{- "-Dtemn.msf.stream.vendor.outbox=kafka"| indent 1 }}
{{- "-Dtemn.msf.ingest.is.cloud.event=false"| indent 1 }}
{{- "-Dtemn.msf.stream.kafka.sasl.enabled=true"| indent 1 }}
{{- "-Dtemn.outbox.events.delivery.direct=true"| indent 1 }}
{{- "-Dtemn.msf.metering.TRANSACT.scheduler.host=https://"| indent 1 }}
{{- .Values.domainname }}{{ "/irf-provider-container/" }}
{{- "-Xms4G -Xmx6G" | indent 1 }}
{{- if .Values.uxp.debugLogs }}
{{- "-DedgeSystemDebug=Y" | indent 1 }}
{{- "-DedgeSystemDebugFolder=$BRP_HOME/logs" | indent 1 }}
{{- end }}
{{- if .Values.CustomJavaOpts.APP.enabled }}
{{- .Values.CustomJavaOpts.APP.JavaOpts| indent 1 }}
{{- end }}
{{- end }}

{{/*
JAVA_OPTS for API POD
*/}}
{{- define "java.opts.api" }}
{{- "-Xms4G -Xmx7G" }}
{{- if eq .Values.temnmonitor.enabled true }}
{{- "-Dtemn.meter.exporter.host=" | indent 1}}
{{- .Values.meter.host }}
{{- "-Dtemn.meter.exporter.port=" | indent 1}}
{{- .Values.meter.port }}
{{- "-Dtemn.meter.enable.jmx=" | indent 1}}
{{- .Values.meter.jmx }}
{{- "-Dtemn.meter.disabled=false" | indent 1}}
{{- "-Diris.monitoring.enabled=true" | indent 1}}
{{- "-Dtemn.tracer.host=" | indent 1}}
{{- .Values.tracer.host }}
{{- "-Dtemn.tracer.port=" | indent 1}}
{{- .Values.tracer.port }}
{{- "-Dtemn.tracer.runtime=" | indent 1}}
{{- .Values.tracer.runtime }}
{{- "-Dtemn.tracer.disabled=false" | indent 1}}
{{- "-Diris.tracing.enabled=true" | indent 1}}
{{- end }}
{{- if eq .Values.environment "aks" }}
{{- " -Dmda.registry.url=https://"| indent 1 }}
{{- .Values.config.name }}{{"genericconfigapp.azurewebsites.net/api/v2.0.0/system/configurationGroups/{}/configuration/{}"}}
{{- end }}
{{- if .Values.CustomJavaOpts.API.enabled }}
{{- .Values.CustomJavaOpts.API.JavaOpts| indent 1 }}
{{- end }}
{{- end }}
{{/*
JAVA_OPTS for WEB POD
*/}}
{{- define "java.opts.web" }}
{{- "-Xms4G -Xmx5G" }}
{{- if not .Values.deployTE.enabled  }}
{{- "-Dauthfilter.options.browserSessionUidCheckEnabled=\"N\""| indent 1 }}
{{- "-Dbrowser.options.fullExternalCommandAccess=\"Y\""| indent 1 }}
{{- end }}
{{- if .Values.uxp.debugLogs }}
{{- "-DedgeSystemDebug=Y" | indent 1 }}
{{- "-DedgeSystemDebugFolder=$LOG_HOME/UXPB" | indent 1 }}
{{- end }}
{{- if .Values.CustomJavaOpts.WEB.enabled }}
{{- .Values.CustomJavaOpts.WEB.JavaOpts| indent 1 }}
{{- end }}
{{- end }}