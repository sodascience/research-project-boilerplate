# SoDa Research Project Boilerplate

This repository contains the template of a research project within the SoDa organisation. It can be used as a starting point for a new research project.

### Getting started

To use this template for your new project:

1. Click the green button on the top of the page "Use this template" and choose "Create a new repository".
2. Choose the Owner as "sodascience"
3. Choose the Repository name (the name of your project)
4. Adjust the visibility of your repository
> Private repositories are visible/accessible only for the owner and other manually assigned contributors.
5. Cleanup: Delete this Readme file and use the template under .github/README_TEMPLATE.md to create your own project Readme.
6. Remove .gitkeep files from folders you don't need or that already contain some git-tracked files.

Now you can start to work on your project.

### Folder Structure
The structure that we created here is a common good practice for python projects and is recommented to stick to it. Nevertheless, feel free to extend/change it at your needs. Here is a short description of the folders:

```
├── .github/         # GitHub Actions workflows & configurations
├── data/            # Raw and processed data
│   ├── raw/         # Raw data (read-only)
│   └── processed/   # Data processed by scripts
├── notebooks/       # Jupyter notebooks: exploration & analysis
├── src/             # Main folder for source code (scripts)
├── .gitignore       # Specifies files to ignore in version control
├── LICENSE.txt      # Project license
├── README.md        # Project overview and documentation
└── env.example      # Example environment variables
```

