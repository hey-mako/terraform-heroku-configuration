output "pipeline" {
  value = <<EOF

heroku_app.application.*.name =

${join("\n", heroku_app.application.*.name)}

heroku_app.application.*.heroku_hostname =

${join("\n", heroku_app.application.*.heroku_hostname)}
EOF
}
