{{- define "restaurant-sentiment.name" -}}
{{- default .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default app name
*/}}
{{- define "restaurant-sentiment.fullname" -}}
{{- $name := default .Chart.Name}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart version specific full name
*/}}
{{- define "restaurant-sentiment.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "restaurant-sentiment.labels" -}}
helm.sh/chart: {{ include "restaurant-sentiment.chart" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/part-of: {{ include "restaurant-sentiment.name" . }}
{{- end -}}

{{/*
Selector labels for a specific component (app, model-service)
Usage: {{ include "restaurant-sentiment.selectorLabels" (dict "root" . "component" "app") }}
*/}}
{{- define "restaurant-sentiment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "restaurant-sentiment.componentName" . }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end -}}

{{/*
Full name for a specific component (app, model-service)
Usage: {{ include "restaurant-sentiment.componentFullname" (dict "root" . "component" "app") }}
*/}}
{{- define "restaurant-sentiment.componentFullname" -}}
{{- $componentDefaultName := .component -}}
{{- printf "%s-%s" (include "restaurant-sentiment.fullname" .root) (default $componentDefaultName) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Name for a specific component (app, model-service) for app.kubernetes.io/name label
Usage: {{ include "restaurant-sentiment.componentName" (dict "root" . "component" "app") }}
*/}}
{{- define "restaurant-sentiment.componentName" -}}
{{- printf "%s-%s" (include "restaurant-sentiment.name" .root) .component | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
App service name
*/}}
{{- define "restaurant-sentiment.app.fullname" -}}
{{- include "restaurant-sentiment.componentFullname" (dict "root" . "component" "app") -}}
{{- end -}}

{{/*
Model-service service name
nameOverride allows the base name of the model service to be configurable.
*/}}
{{- define "restaurant-sentiment.modelService.fullname" -}}
{{- include "restaurant-sentiment.componentFullname" (dict "root" . "component" (default "model-service" .Values.modelService.nameOverride) "nameOverride" .Values.modelService.nameOverride) -}}
{{- end -}}