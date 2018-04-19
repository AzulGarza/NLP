import csv
import numpy as np
import emoji
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
import io


def read_glove_vecs(glove_file):
    with io.open(glove_file, 'r', encoding='utf8', errors='ignore') as f:
        csvReader = csv.reader(f)
        words = set()
        word_to_vec_map = {}
        for row in csvReader:
            curr_word = row[0]
            words.add(curr_word)
            word_to_vec_map[curr_word] = np.array(row[1:], dtype=np.float64)

        i = 1
        words_to_index = {}
        index_to_words = {}
        for w in sorted(words):
            words_to_index[w] = i
            index_to_words[i] = w
            i = i + 1
    return words_to_index, index_to_words, word_to_vec_map


def softmax(x):
    e_x = np.exp(x - np.max(x))
    return e_x / e_x.sum()


def read_csv(filename='data/emojify_data.csv'):
    phrase = []
    emoji = []

    with io.open(filename, encoding='utf8') as csvDataFile:
        csvReader = csv.reader(csvDataFile)

        for row in csvReader:
            phrase.append(row[0])
            emoji.append(row[1])

    X = np.asarray(phrase)
    Y = np.asarray(emoji, dtype=int)

    return X, Y


def convert_to_one_hot(Y, C):
    Y = np.eye(C)[Y.reshape(-1)]
    return Y


emoji_dictionary = {
    "0": ":smile:",
    "1": ":disappointed:",
    "2": ":rage:",
    "3": ":yum:",
    "4": ":heart:",
    "5": ":thumbsup:",
    "6": ":thumbsdown:",
    "7": ":clap:",
    "8": ":telephone:",
    "9": ":moneybag:",
    "10": ":smoking:",
    "11": ":soccer:",
    "12": ":bikini:",
    "13": ":x:",
    "14": ":raised_hands:",
    "15": ":ok_hand:"
}


def label_to_emoji(label):
    return emoji.emojize(emoji_dictionary[str(label)], use_aliases=True)


def print_predictions(X, pred):
    print()
    for i in range(X.shape[0]):
        print(X[i], label_to_emoji(int(pred[i])))


def plot_confusion_matrix(y_actu, y_pred, title='Confusion matrix', cmap=plt.cm.gray_r):

    df_confusion = pd.crosstab(y_actu, y_pred.reshape(y_pred.shape[0],), rownames=['Actual'], colnames=['Predicted'], margins=True)

    df_conf_norm = df_confusion / df_confusion.sum(axis=1)

    plt.matshow(df_confusion, cmap=cmap)  # imshow
    # plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(df_confusion.columns))
    plt.xticks(tick_marks, df_confusion.columns, rotation=45)
    plt.yticks(tick_marks, df_confusion.index)
    # plt.tight_layout()
    plt.ylabel(df_confusion.index.name)
    plt.xlabel(df_confusion.columns.name)


def predict(X, Y, W, b, word_to_vec_map):
    m = X.shape[0]
    pred = np.zeros((m, 1))

    for j in range(m):
        words = X[j].lower().split()
        avg = np.zeros((300,))
        for w in words:
            try:
                avg += word_to_vec_map[w]
            except KeyError as e:
                print(e.args[0])
        avg = avg/len(words)

        Z = np.dot(W, avg) + b
        A = softmax(Z)
        pred[j] = np.argmax(A)

    print("Accuracy: " + str(np.mean((pred[:] == Y.reshape(Y.shape[0], 1)[:]))))

    return pred
