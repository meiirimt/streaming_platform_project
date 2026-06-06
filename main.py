import pandas as pd
from sqlalchemy import create_engine

engine = create_engine(
    "postgresql://postgres:08052009Mt@localhost:5432/streaming_platform"
)

views = pd.read_sql("""
SELECT
    v.*,
    c.title,
    g.genre_name
FROM views v
JOIN content c ON v.content_id = c.content_id
JOIN genres g ON c.genre_id = g.genre_id
""", engine)

users = pd.read_sql(
    "SELECT * FROM users",
    engine
)

print("Данные загружены")

# Преобразование даты

views['watch_date'] = pd.to_datetime(
    views['watch_date']
)

# Удаление пустых значений

views = views.dropna()

print("Очистка данных завершена")


views['month'] = views['watch_date'].dt.month

monthly_views = (
    views.groupby('month')
    .size()
    .reset_index(name='views')
)

monthly_views['rolling_mean'] = (
    monthly_views['views']
    .rolling(3)
    .mean()
)

print(monthly_views)


pivot_table = pd.pivot_table(
    views,
    values='watch_minutes',
    index='month',
    columns='genre_name',
    aggfunc='mean'
)

print(pivot_table)

monthly_views['growth_percent'] = (
    monthly_views['views']
    .pct_change() * 100
)

print(monthly_views)


active_users = views['user_id'].nunique()

registered_users = users['user_id'].nunique()

retention = (
    active_users /
    registered_users
) * 100

print(f"Retention Rate = {retention:.2f}%")

график код:
import pandas as pd
import matplotlib.pyplot as plt
from sqlalchemy import create_engine

# Подключение к PostgreSQL

engine = create_engine(
    "postgresql://postgres:08052009Mt@localhost:5432/streaming_platform"
)

# Загрузка данных

views = pd.read_sql("""
SELECT
    v.*,
    c.title,
    g.genre_name
FROM views v
JOIN content c ON v.content_id = c.content_id
JOIN genres g ON c.genre_id = g.genre_id
""", engine)

users = pd.read_sql(
    "SELECT * FROM users",
    engine
)

subscriptions = pd.read_sql(
    "SELECT * FROM subscriptions",
    engine
)

# Подготовка даты

views['watch_date'] = pd.to_datetime(
    views['watch_date']
)

views['month'] = views['watch_date'].dt.month

# ====================================
# 1. LINE CHART
# Просмотры по месяцам
# ====================================

monthly_views = (
    views.groupby('month')
    .size()
    .reset_index(name='views')
)

plt.figure(figsize=(8,5))
plt.plot(
    monthly_views['month'],
    monthly_views['views']
)
plt.title('Views by Month')
plt.xlabel('Month')
plt.ylabel('Views')
plt.grid(True)
plt.show()

# ====================================
# 2. BAR CHART
# ТОП-5 фильмов
# ====================================

top_movies = (
    views.groupby('title')
    .size()
    .sort_values(ascending=False)
    .head(5)
)

plt.figure(figsize=(8,5))
top_movies.plot(kind='bar')
plt.title('Top 5 Movies')
plt.xlabel('Movie')
plt.ylabel('Views')
plt.show()

# ====================================
# 3. PIE CHART
# Статусы подписок
# ====================================

status_counts = (
    subscriptions['status']
    .value_counts()
)

plt.figure(figsize=(7,7))
plt.pie(
    status_counts,
    labels=status_counts.index,
    autopct='%1.1f%%'
)
plt.title('Subscription Status Distribution')
plt.show()

# ====================================
# 4. SCATTER PLOT
# Возраст и просмотры
# ====================================

user_watch = (
    views.groupby('user_id')['watch_minutes']
    .sum()
    .reset_index()
)

scatter_data = pd.merge(
    users,
    user_watch,
    on='user_id'
)

plt.figure(figsize=(8,5))
plt.scatter(
    scatter_data['age'],
    scatter_data['watch_minutes']
)
plt.title('Age vs Watch Minutes')
plt.xlabel('Age')
plt.ylabel('Watch Minutes')
plt.show()

# ====================================
# 5. HISTOGRAM
# Распределение возраста
# ====================================

plt.figure(figsize=(8,5))
plt.hist(
    users['age'],
    bins=10
)
plt.title('Age Distribution')
plt.xlabel('Age')
plt.ylabel('Frequency')
plt.show()
