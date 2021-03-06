### X.X puppetenv_git and puppetenv_rev (**optional**)

**default value**: `master`

Package installation and configuration - provisioning - of the cluster
is mainly done by [Puppet](https://en.wikipedia.org/wiki/Puppet_(software)).
Magic Castle provides Puppet environments as a git repo. The puppet modules,
site configuration and hieradata are defined in the git repo
[puppet-magic_castle repo](https://github.com/ComputeCanada/puppet-magic_castle/).

When you download a release of Magic Castle, the `puppetenv_git` variable point to
the `puppet-magic_castle` git repo and `puppetenv_rev` to a specific tag. You can
fork the repo and configure your cluster as you would like by making `puppetenv_git`
points toward your own repo. `puppetenv_rev` points to the `master` branch when
using the Magic Castle git repo instead of the release archive.

To get more details on the configuration of each host per arrangement,
look at the [puppet-magic_castle repo](https://github.com/ComputeCanada/puppet-magic_castle/).

#### X.X.1 Post Build Modification Effect

Modifying this variable after the cluster is built leads to a complete
cluster rebuild at next `terraform apply`.