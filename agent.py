import subprocess

def run_agent(task):
    print(f"Agent starting task: {task}")
    # මෙතනදී අපි සෘජුවම terminal commands run කරනවා
    result = subprocess.run(task, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error detected: {result.stderr}")
        print("Agent is fixing the error...")
    else:
        print("Success!")
        print(result.stdout)

if __name__ == "__main__":
    # මෙතනට ඕනෑම task එකක් දෙන්න පුළුවන්
    run_agent("cd medicine_app && flutter pub add camera")