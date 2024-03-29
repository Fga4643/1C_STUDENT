Процедура ОбработкаПроведения(Отказ,Режим)
	Движения.ОстаткиМатериалов.Записывать = Истина;
	Движения.СтоимостьМатериалов.Записывать = Истина;
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|    ОказаниеУслугиПереченьНоменклатуры.Номенклатура,
	|    ОказаниеУслугиПереченьНоменклатуры.Номенклатура.ВидНоменклатуры КАК ВидНоменклатуры,
	|    СУММА(ОказаниеУслугиПереченьНоменклатуры.Количество) КАК КоличествоВДокументе,
	|    МАКСИМУМ(ОказаниеУслугиПереченьНоменклатуры.Стоимость) КАК Стоимость
	|ИЗ
	|    Документ.ОказаниеУслуги.ПереченьНоменклатуры КАК ОказаниеУслугиПереченьНоменклатуры
	|ГДЕ
	|    ОказаниеУслугиПереченьНоменклатуры.Ссылка = &Ссылка
	|СГРУППИРОВАТЬ ПО
	|    ОказаниеУслугиПереченьНоменклатуры.Номенклатура,
	|    ОказаниеУслугиПереченьНоменклатуры.Номенклатура.ВидНоменклатуры";
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если ВыборкаДетальныеЗаписи.ВидНоменклатуры = Перечисления.ВидыНоменклатуры.Материал Тогда
			// регистр ОстаткиМатериалов – Расход
			Движение = Движения.ОстаткиМатериалов.Добавить();
			Движение.Период = Дата;
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Склад = Склад;
			Движение.Количество = ВыборкаДетальныеЗаписи.КоличествоВДокументе;
			// Регистр СтоимостьМатериалов – Расход
			Движение = Движения.СтоимостьМатериалов.Добавить();
			Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
			Движение.Период = Дата;
			Движение.Материал = ВыборкаДетальныеЗаписи.Номенклатура;
			Движение.Стоимость = ВыборкаДетальныеЗаписи.КоличествоВДокументе * ВыборкаДетальныеЗаписи.Стоимость;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры