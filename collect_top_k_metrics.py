sep='\t'
header = ['Model', 'filt: h@1',	'filt: h@3', 'filt: h@10', 'filt: MR', 'filt: MRR', 'h@1', 'h@3', 'h@10', 'MR', 'MRR']
for dataset in 'FB15K WN18 FB15K-237 WN18RR'.split():
    with open('link_prediction_%s.csv' % dataset, 'w', encoding='utf-8') as f:
        f.write(sep.join(header) + '\n')
        for model in 'TransE HOLE DistMult ComplEx'.split():
            results = [model]

            logs = [line.strip() for line in open('../%s_%s/log.txt' % (dataset, model), 'r') if line.strip()]
            job_id = '0:'
            logs = [line[line.find(job_id) + len(job_id):].strip() if line.startswith(job_id) else line for line in logs]
            start = logs.index('no type constraint results:')
            end = logs.index('type constraint results:')
            logs = logs[start: end]
            logs = [line for line in logs if line.startswith('averaged')]
            assert len(logs) == 2
            logs = [[metric.strip() for metric in line.split('\t') if metric.strip()][1:] for line in logs]
            assert len(logs[0]) == len(logs[1]) == 5
            results.extend(reversed(logs[1]))
            results.extend(reversed(logs[0]))
            f.write(sep.join(results) + '\n')
