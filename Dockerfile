# Use a lightweight Python base image compatible with CrewAI requirements
# (Python >=3.10, <3.13).
FROM python:3.12-slim-bookworm

# Set the working directory inside the container
WORKDIR /app

# Install UV for Python dependency management
RUN pip install --no-cache-dir uv

# Copy dependency files first for better caching
COPY pyproject.toml uv.lock ./

# Install the CrewAI package via uv
RUN uv pip install crewai --system

# Install project dependencies
RUN crewai install

# Copy the rest of the application code
COPY . .

# Set entrypoint and default command to run the CrewAI script
ENTRYPOINT ["crewai"]
CMD ["run"]

# Reminder: API keys (.env file) must be provided via environment variables when running the container