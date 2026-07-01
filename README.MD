# SoDa Research Project Boilerplate

## General Information

This repository contains the template of a typical research project within the SoDa organisation. It can be used as a starting point for a new research project.

### Getting started

To use this template for your new project, follow these steps in order:

#### Step 1 - Create your own repository from this template
Click the green button at the top of the page labelled "Use this template" and choose "Create a new repository".

#### Step 2 - Set the owner
Choose the Owner as "sodascience"

#### Step 3 - Choose the name of your project

Choose the Repository name (the name of your project)

#### Step 4 - Adjust the visibility of your repository

Adjust the visibility of your repository (public or private).
 
> Private repositories are visible/accessible only for the owner and other manually assigned contributors. **Note:** visibility only controls who can *see* the code — it does not change our no-data-in-git policy. Even in a private repo, raw or sensitive data should never be committed to git (see the `data/` folder note below).

#### Step 5 - Clean up placeholder files

Remove `.gitkeep` files from folders you don't need, or from folders that already contain some git-tracked files.
 
> **What is a `.gitkeep` file?** Git only tracks files, not empty folders — so an empty folder like `data/raw/` would simply disappear when someone else clones the repo. To keep the folder structure visible and intact, we add an empty placeholder file named `.gitkeep` inside it. So, we used `.gitkeep` files to make sure your new project repo has the same folder structure as this template. Once a folder contains real files, the placeholder no longer serves a purpose, so you can safely delete it. If you don't need a folder at all (e.g. `notebooks/` if you won't use notebooks), you can delete the whole folder.

#### Step 6 - Review the included GitHub Actions workflow

The current `.github` folder contains a simple linter job that checks your code for formatting errors, and runs automatically every time you push code or open a pull request. It is recommended to keep it as is; if you want to develop project-specific workflows, refer to GitHub's [official documentation about workflows](https://docs.github.com/en/actions/using-workflows/about-workflows).
 
#### Step 7 — Fill in your README
 
When done reading this guide, scroll to the [README template](#readme-template) below and follow the instructions there.
 
---
 
Once you've completed these steps, you're ready to start working on your project.


### Folder Structure
The structure that we created here is common good practice for research projects, and we recommend sticking to it — whether your project uses Python, R, or both. Nevertheless, feel free to extend/change it to your needs. Here is a short description of the folders and files:

```
├── .github/         # GitHub Actions workflows & configurations
├── data/            # Raw and processed data
│   ├── raw/         # Raw data (read-only)
│   └── processed/   # Data processed by scripts
├── notebooks/       # Exploration & analysis: Jupyter (.ipynb) or R Markdown/Quarto (.Rmd / .qmd)
├── src/             # Main folder for source code (scripts)
├── .gitignore       # Specifies files to ignore in version control
├── LICENSE.txt      # Project license
├── README.md        # Project overview and documentation
└── env.example      # Example environment variables
```

> **Using R instead of Python?** Keep code in `src/` as shown above — we don't use a separate `R/` folder for non-package projects. An R package project would be developed as a from-scratch repository. Dependency management files (`pyproject.toml`/`uv.lock` for Python, `renv.lock` for R), and an `.Rproj` file if you use RStudio, aren't included in this template — add them as needed once you set up your environment. 

> **What is `env.example`?** Projects sometimes need secrets or machine-specific settings (API keys, database passwords, file paths) that must never be committed to git. The convention is to list these as placeholders in a file called `env.example`, which *is* committed. Each contributor then copies it to a new file named `.env` and fills in their own real values. `.env` is already listed in `.gitignore`, so your personal secrets never get pushed to GitHub.

## README template

> TODO: Please delete everything above this section from the README. Therefore, you will end up with a clean template for your project README file. Make sure to replace all placeholders below (marked as `[PROJECT NAME]`, etc.) with your project-specific information.

# [PROJECT NAME]
 
<!--
Badges section: 
- Project Status Badge: pick one status available from the following list that matches the current status of the project and replace the badge below accordingly:
    - concept      -> no real implementation yet, demo/proof-of-concept only
    - wip          -> in development, no stable/usable release yet
    - suspended    -> development paused, but you intend to resume
    - abandoned    -> stopped for good, no stable release was ever reached
    - active       -> stable, usable, and actively maintained
    - inactive     -> stable and usable, but no longer actively developed
    - unsupported  -> stable, usable, but author(s) have stopped all support
    - moved        -> repo relocated; see https://www.repostatus.org/#moved for required alt-text format
- DOI Badge: if the project has a DOI, replace the badge below or delete this line 
- UV usage is recommended, if your project doesn't use it remove swap the badge with the one corresponding to your python package manager of choice (e.g. pip, conda, etc.).

You can find badges here also they explain how you can set up a custom badge https://shields.io/badges  

-->
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) 
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.XXXXXXX.svg)](https://zenodo.org/doi/10.5281/zenodo.XXXXXXX)
![uv](https://img.shields.io/endpoint?url=https://raw.githubusercontent.com/astral-sh/uv/main/assets/badge/v0.json)

__Project Goal and Description__ - Add a brief description of the project. What is the problem you are trying to solve? What is your proposed solution? What is the impact of your project?

## Highlights
- Add highlights of your project. These can be anything that you think is important to mention.

## Installation
Add installation instructions here. For example for a staged pipeline you can show the commands that run each stage separately like the following:

Example installation instructions for python:
```sh
# Python (uv)
uv sync
uv run python main.py --stage preprocessing
uv run python main.py --stage modelling
```

Example installation instructions for R:
```r
# R (renv)
renv::restore()
Rscript main.R 
```

## Usage
Add a brief description of how to use your project. 

## Citation

Information about citation Latex-style code, if applicable.

For example:

```bibtex
@software{[project_name],
  author  = {[Author Name]},
  title   = {[Project Name]},
  year    = {[Year]},
  doi     = {10.5281/zenodo.XXXXXXX},
  url     = {https://github.com/sodascience/[PROJECT_NAME]}
}
```

## Contributing

Contributions are welcome! Please see our [contribution guidelines](https://github.com/sodascience/Github_Manifest) for details on branching strategy, commit conventions and recommendations for pull requests process. 

Found a bug or have suggestions? Feel free to open an issue in the [issue tracker](https://github.com/sodascience/[PROJECT_NAME]/issues)

## Contact
**[PROJECT NAME]** is a project by the [ODISSEI Social Data Science (SoDa)](https://odissei-data.nl/nl/soda/) team.
Do you have questions, suggestions, or remarks on the technical implementation? Create an issue in the [issue tracker](https://github.com/sodascience/[PROJECT_NAME]/issues) or feel free to contact [Contact Person](https://github.com/ContactPerson).

<img src="img/logos/soda.png" alt="SoDa logo" width="250px"/> 
