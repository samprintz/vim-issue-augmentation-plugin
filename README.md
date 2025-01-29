# Vim GitHub Issue Augmentation Plugin

A plugin for vim that augments GitHub issue IDs with their title.

For instance, the markdown text

```
- Finished #5432
- Working on #5433
- Next: #5434, #5435
```

renders to:

![20231122-140129-screenshot](https://github.com/samprintz/vim-issue-augmentation-plugin/assets/7581457/27cfd16c-3245-4991-8c6a-6ae0c341df0c)


This plugin is inspired by https://github.com/samprintz/obsidian-issue-augmentation-plugin.

## Configuration

The mapping of issue IDs to descriptive issue texts must be a comma-separated file
and can be specified in the `.vimrc` by setting the variable
`g:github_issue_map_file`.
For the example above, it might look like this:

```
5432,My issue
5433,Another issue
5434,Some bug
5435,Cool feature
```

A node script to automatically fetch such a mapping file is provided in https://github.com/samprintz/fetch-github-titles.
