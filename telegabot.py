import telebot
import requests
import time
import os
from subprocess import run, Popen, PIPE
from sys import executable
from pathlib import Path

API_TOKEN = 'some_api'
bot = telebot.TeleBot(API_TOKEN)

# Handle '/start' and '/help'
@bot.message_handler(commands=['help', 'start'])
def send_welcome(message):
    bot.reply_to(message, """\
 Поиск книги из Колхоза производится по фразе, включающую имя автора и заголовок - 
kx3@фраза
 Этот запрос возвратит номер книги. Запрос книги из Колхоза - 
kx3$12345
 12345 - номер книги

 Поиск книги из Либрусека производится по фразе, включающую имя автора и заголовок - 
lrs@автор@заголовок
 Этот запрос возвратит номер книги. Запрос книги из Либрусека - 
lrs$12345
12345 - номер книги.
 Например, нам нужен Дж. Фрэзер, Золотая Ветвь - делаем запрос на Либрусек -
lrs@Фрэзер@Золотая
 Он вернет - 
№349568: Фрэзер Джеймс Джордж(3). Золотая ветвь
 Запрашиваем книгу -
lrs$349568
 Вуаля.
""")

# Handle all other messages with content_type 'text' (content_types defaults to ['text'])
@bot.message_handler(func=lambda message: True)
def echo_message(message):
 # print(message.from_user.username+':'+message.text)
 book="_";
 
 if message.text[0:3]=="kx3":  #колхоз
  bot.reply_to(message,"Запрос в Колхоз:")   
  book=requests.get('http://localhost/semargl/kolxo3_get_file.php?book='+message.text).text
  
 if message.text[0:3]=="lrs": #либрусек
  bot.reply_to(message,"Запрос в Либрусек:")
  book=run('c:\lazarus\components\mathliba\l.liebrusec\project1.exe '+message.text, shell = True, capture_output = True, encoding='cp866')
  bot.reply_to(message,book.stdout)
  book=book.stdout;
  
 if book[0]==":":     #какая-то ошибка
  bot.reply_to(message,book)
  print(book)
 elif book[0]=="F":   #Шлем книгу
  book=book[1:]
  my_file=Path(book)
  try:
   my_file.resolve(strict=True)
  except FileNotFoundError:
   bot.reply_to(message,book)
   bot.reply_to(message,"Увы, файл найден в БД, но не найден на диске. Напишите об этом мне - @su27k")
   print("Увы, файл найден в БД, но не найден на диске.")
  else:
   res=str(os.path.getsize(book))+':'+book
   print(str(os.path.getsize(book))+':'+book)
   bot.reply_to(message, 'Книга найдена, '+str(os.path.getsize(book))+' байт. Сейчас вышлем, подождите несколько минут.')
   #bot.reply_to(message, book)
   doc = open(book, 'rb')
   try:
    bot.send_document(message.chat.id, doc, timeout=600)
   except:
    time.sleep(5)
    bot.send_document(message.chat.id, doc, timeout=600)
   doc.close()
    

  

  
bot.infinity_polling()
