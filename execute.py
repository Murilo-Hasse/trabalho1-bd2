import psycopg2
import re

credentials = {
    'dbname': 'postgres',
    'user': 'postgres',
    'password': 'postgres',
    'host': 'localhost',
    'port': 5432
}

def caculate_mean_time(query: str, quantity: int):
    connection = psycopg2.connect(**credentials)
    cursor = connection.cursor()
    
    queries = list()
    
    for i in range(0, quantity):
        cursor.execute('DISCARD PLANS;')
        cursor.execute(f'EXPLAIN ANALYSE {query};')
        result = cursor.fetchall()
        
        pattern = r'\d+\.\d+'
        
        planning_time = float(re.findall(pattern, result[-2][0])[0])
        execution_time = float(re.findall(pattern, result[-1][0])[0])
        
        total_query_time = planning_time + execution_time
        queries.append(total_query_time)
    
    average = sum(queries) / quantity
    
    cursor.close()
    connection.close()
    
    return average
    
if __name__ == '__main__':
    average = caculate_mean_time("""
                       SELECT * FROM bar;
                       """, 
                       100)
    
    print(average)