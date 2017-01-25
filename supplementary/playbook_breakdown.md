# Bio-ansible playbook breakdonw

## Roles and playbooks

### Need `sudo`

#### common.yml

- [make_sw_guy](../roles/make_sw_guy/tasks) - makes non privileged guy to install all the bio-tools
- [common](../roles/common/tasks) - `apt-get` stuff, `pip` and `R` language with dependencies
- [lmod](../roles/lmod/tasks) - installs [lmod](https://www.tacc.utexas.edu/research-development/tacc-projects/lmod) environmental modules system

#### interactive.yml

- [interactive](../roles/interactive/tasks) - installs RStudio and Shinny
- [nginx](../roles/nginx/tasks)

### Don't need `sudo`

#### bio.yml

- [bds](../roles/bds/tasks) - installs [BigDataScript](https://pcingola.github.io/BigDataScript/) 
- [bio_tools](../roles/bio_tools/tasks) - installs biological tool, which could mean anything :)
- [extras](../roles/extra/tasks) - non essential tools e.g `node.js`
- [java](../roles/java/tasks) - this one is obvious, Oracle Java
- [make_dirs](../roles/make_dirs/tasks) - provides directory hierarchy 
