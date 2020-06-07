import os 
import sys
import pandas as pd

def read_map(arq_path):

    mAP = []
    carmAP = []
    busmAP = []
    motmAP = []
    iou = []
    
    arq = open(arq_path, "r")

    while(1):
        line = arq.readline()
        if "mAP@" in line:
            mAP.append(float(line.split(' ')[-3]))
        if "car" in line:
            carmAP.append(float(line.split(' ')[8].split('%')[0]))
        if "bus" in line:
            busmAP.append(float(line.split(' ')[8].split('%')[0]))
        if "motorcycle" in line:
            motmAP.append(float(line.split(' ')[8].split('%')[0]))
        if "average IoU" in line:
            iou.append(float(line.split(' ')[-3]))
        if line == '':
            break
    return mAP, carmAP, busmAP, motmAP, iou


DATA_PATH = str(sys.argv[1])
CFG_PATH = str(sys.argv[2])
WEIGHTS_PATH = str(sys.argv[3])  
THRESH = "" if len(sys.argv) <= 4 else str(sys.argv[4])

#pegando os nomes dos arquivos da pasta
for i in os.walk(WEIGHTS_PATH):
    f = i
    break
f = f[2]

if(" " in WEIGHTS_PATH):
    WEIGHTS_PATH = WEIGHTS_PATH.replace(" ", "\ ")

#filtrando os nomes para pegar so os pesos
prov = []
for arq in f:
    if arq.split(".")[-1] != "weights" or "final" in arq or "last" in arq or "100." in arq:
        prov.append(arq)
for a in prov:
    f.remove(a)
 
for i in range(len(f)):
    cmd = "./darknet detector map " + DATA_PATH + " " + CFG_PATH + " " + WEIGHTS_PATH + f[i] + " -iou_thresh "+ THRESH + "> map.txt"
    os.system(cmd)
    mAP, carmAP, busmAP, motmAP, iou = read_map("map.txt")
    os.system("rm map.txt")
        
for i in range(len(f)):
    f[i] = int(f[i].split('_')[-1].split('.')[0])

data = {"Iterations": f, "Avg_mAP": mAP,
				"car": carmAP,
					"bus": busmAP,
						"motorcycle": motmAP,
							"Avg_IOU": iou}

MAIN_DIR = WEIGHTS_PATH.replace("\ ", " ").split("weights")[0] 

df = pd.DataFrame(data)
df = df.sort_values("Iterations")
df.to_csv(WEIGHTS_PATH.replace("\ ", " ").split("weights")[0] + "valid_map.csv")

# salvando uma copia dos melhores pesos na pasta principal da configuracao
max_map = df.idxmax()["Avg_mAP"]
cmd = "cp " + WEIGHTS_PATH + "*" + str(df["Iterations"][max_map]) + ".weights" + " " + MAIN_DIR + "best.weights"

os.system(cmd)

# agora testando os melhores pesos no conjunto de testes e salvando o resultado em um arquivo. precisamos alterar o data_file para o conjunto de teste no lugar do de validação
datafile = open(DATA_PATH, "rw")
datastr = datafile.read().replace("valid.txt", "test.txt")
datafile.seek(0)
datafile.truncate(0)
datafile.write(datastr)

cmd = "./darknet detector map " + DATA_PATH + " " + CFG_PATH + " " + MAIN_DIR + "best.weights" + " -iou_thresh " + THRESH + "> " + MAIN_DIR + "test_mAP.txt"
os.system(cmd)
