# Module 1 homework: Docker & Terraform Ho

## How to make sense of this HW

1. Used docker compose provided in the Homework
2. `pipeline.py` is called by `call_pipeline_py.sh`
   - The script fetches the data using `wget` command and stores them in `data` directory
3. The data are then loaded from local directory with pandas and then loaded in batches
   to postgres db
4. SQL scripts are stored in `scripts/homework.sql`. Each answer has a subquery and to
   run get the answers, uncomment one of the select statements at the bottom
5. I have played with docker and terraform following the pre-recorded videos. For the
   terraform answer, I simply ran terraform cli commands (e.g. `terraform apply -h`)

> **Note: The answers are tied up to the questions at the time.**

- Questions can be found at this [url](https://github.com/DataTalksClub/data-engineering-zoomcamp/blob/main/cohorts/2025/01-docker-terraform/homework.md#question-3-trip-segmentation-count)
- The answers in the `homework.md` file are correct
