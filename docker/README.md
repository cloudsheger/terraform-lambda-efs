## How to build and Run this dockerfile locally.

You can build this Dockerfile with the command:

```docker build -t my-terraform . ```
And then you can run the container with the command:

```docker run -it --rm my-terraform <terraform command> ```

### You can replace <terraform command> with any valid Terraform command (e.g. plan, apply, destroy).