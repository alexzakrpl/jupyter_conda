# Используем компактный базовый образ на основе Debian/Alpine
FROM continuumio/miniconda3:latest

# Устанавливаем Jupyter и необходимые зависимости
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Создаем рабочую директорию
WORKDIR /workspace

# Создаем conda-окружение для проекта
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml && \
    conda clean -a && \
    echo "source activate myenv" > ~/.bashrc

# Устанавливаем JupyterLab и дополнительные зависимости
RUN conda install -n myenv -c conda-forge \
    jupyterlab notebook && \
    conda clean -a

# Активируем окружение и указываем путь к нему
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Экспортируем порт Jupyter
EXPOSE 8888

# Запускаем Jupyter Notebook
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''"]

