#include "SocketData.h"

SocketData::SocketData(int code , string buf)
{
	this->code = code;
	this->buf = buf;
}

SocketData::~SocketData()
{
}

