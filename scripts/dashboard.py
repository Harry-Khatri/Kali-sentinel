from flask import Flask, render_template_string, request
import os, glob, csv, json
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def index():
    log_dir = './logs'
    all_reports = sorted(glob.glob(f"{log_dir}/summary_*.html"), reverse=True)
    selected = request.args.get('file', 'summary_latest.html')
    selected_path = os.path.join(log_dir, selected) if not selected.startswith('summary_') else f"{log_dir}/{selected}"

    # Load summary HTML
    if not os.path.exists(selected_path):
        content = "<h2>Report not found.</h2>"
    else:
        with open(selected_path, 'r') as f:
            content = f.read()

    # Load threat score
    try:
        with open('./logs/threat_score.txt') as s:
            threat_score = s.read().strip()
    except:
        threat_score = "Unknown"

    # Load threat history
    timestamps, scores, labels = [], [], []
    history_file = './logs/threat_score_history.csv'
    if os.path.exists(history_file):
        with open(history_file, 'r') as f:
            reader = csv.reader(f)
            for row in reader:
                if len(row) >= 2:
                    timestamps.append(row[0])
                    parts = row[1].split()
                    scores.append(int(parts[0]))
                    labels.append(parts[1] if len(parts) > 1 else "")

    options = ''.join([
        f"<option value='{os.path.basename(f)}' {'selected' if os.path.basename(f)==selected else ''}>{os.path.basename(f)}</option>"
        for f in all_reports
    ])

    return render_template_string(f"""
    <!DOCTYPE html>
    <html>
    <head>
        <meta charset='UTF-8'>
        <title>Kali Sentinel Dashboard</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    </head>
    <body style="background:#111; color:#eee; font-family:monospace;">
        <h2 style="color:#0ff;">Kali Sentinel Archive Viewer</h2>
        <h3 style="color:#ff0;">🔥 Threat Score: {threat_score}</h3>
        <form method="get">
            <label style="font-size:16px;">📂 Select a past report:</label>
            <select name="file" onchange="this.form.submit()">
                {options}
            </select>
        </form>
        <hr>
        <a href="/log" target="_blank" style="color:#0ff;">📄 View Cron Log (Live)</a>
        <hr>
        <h3>📊 Threat Score History</h3>
        <canvas id="threatChart" width="800" height="250"></canvas>
        <script>
            const ctx = document.getElementById('threatChart').getContext('2d');
            const timestamps = {json.dumps(timestamps)};
            const scores = {json.dumps(scores)};
            const labels = {json.dumps(labels)};
            const bgColors = scores.map(score => {{
                if (score >= 70) return 'rgba(255, 0, 0, 0.5)';       // Critical
                else if (score >= 30) return 'rgba(255, 165, 0, 0.5)'; // Moderate
                else return 'rgba(0, 255, 0, 0.4)';                    // Safe
            }});

            new Chart(ctx, {{
                type: 'line',
                data: {{
                    labels: timestamps,
                    datasets: [{{
                        label: 'Threat Score',
                        data: scores,
                        backgroundColor: bgColors,
                        borderColor: 'orange',
                        borderWidth: 2,
                        tension: 0.4,
                        fill: true,
                        pointRadius: 6,
                        pointHoverRadius: 8,
                    }}]
                }},
                options: {{
                    responsive: true,
                    plugins: {{
                        tooltip: {{
                            callbacks: {{
                                label: function(context) {{
                                    return "{{labels[context.dataIndex]}} ({{context.parsed.y}})";


                                }}
                            }}
                        }},
                        legend: {{
                            labels: {{ color: '#fff' }}
                        }}
                    }},
                    scales: {{
                        y: {{
                            beginAtZero: true,
                            max: 100,
                            ticks: {{ color: '#ccc' }}
                        }},
                        x: {{
                            ticks: {{ color: '#ccc' }}
                        }}
                    }}
                }}
            }});
        </script>
        <hr>
        {content}
    </body>
    </html>
    """)

@app.route('/log')
def view_log():
    try:
        with open(f'./logs/cron_{datetime.now().strftime("%Y-%m-%d")}.log', 'r') as f:
            lines = f.readlines()[-50:]
        return "<pre style='background:#111;color:#0f0;padding:10px;overflow:auto;max-height:90vh;'>" + ''.join(lines) + "</pre>"
    except FileNotFoundError:
        return "<pre style='color:red;'>Log file not found.</pre>"

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)

