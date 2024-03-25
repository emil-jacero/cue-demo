package test

Repo: "oci://stefanprodan.github.io/podinfo"

if Repo =~ "^http.*" {
    http: true
}
if Repo =~ "^oci.*" {
    http: false
}