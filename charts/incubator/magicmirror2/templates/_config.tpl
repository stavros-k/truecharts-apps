{{/* Define the configmap */}}
{{- define "magicmirror.config" -}}

{{- $configName := printf "%s-magicmirror-config" (include "tc.common.names.fullname" .) }}
{{- $configEnvName := printf "%s-magicmirror-env" (include "tc.common.names.fullname" .) }}

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  config.js: |
    /* Magic Mirror Config Sample
    *
    * By Michael Teeuw http://michaelteeuw.nl
    * MIT Licensed.
    *
    * For more information on how you can configure this file
    * See https://github.com/MichMich/MagicMirror#configuration
    *
    */

    var config = {
      address: "0.0.0.0",
      port: {{ .Values.service.main.ports.main.port }},

      // or add a specific IPv4 of 192.168.1.5 :
      // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.1.5"],
      // or IPv4 range of 192.168.3.0 --> 192.168.3.15 use CIDR format :
      // ["127.0.0.1", "::ffff:127.0.0.1", "::1", "::ffff:192.168.3.0/28"],
      // Set [] to allow all IP addresses
      ipWhitelist: [
        {{- range .Values.magicmirror.ip_whitelist }}
        {{ . | quote }},
        {{- end }}
      ],

      useHttps: false, // Support HTTPS or not, default "false" will use HTTP

      language: {{ .Values.magicmirror.language | quote }},
      timeFormat: {{ .Values.magicmirror.time_format | trimAll "\"" }},
      units: {{ .Values.magicmirror.units | quote }},
      serverOnly: "true",

      modules: [
        {{- range .Values.magicmirror.mm2_modules }}
        {{ . | quote }},
        {{- end }}
      ]

    };

    /*************** DO NOT EDIT THE LINE BELOW ***************/
    if (typeof module !== "undefined") {module.exports = config;}

---

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ $configEnvName }}
  labels:
    {{- include "tc.common.labels" . | nindent 4 }}
data:
  DATA_DIR: /magicmirror2
  UID: {{ .Values.security.PUID | quote }}
  GID: {{ .Values.podSecurityContext.fsGroup | quote }}
  FORCE_UPDATE: {{ .Values.magicmirror.force_update | quote }}
  FORCE_UPDATE_MODULES: {{ .Values.magicmirror.force_update_modules | quote }}
{{- end -}}
