#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <curl/curl.h>

int escapeText(const char* text, char** output) {

  int rc = -1;
  CURL* curl = curl_easy_init();
  if (curl) {
    char* escaped = curl_easy_escape(curl, text, strlen(text));
    if (escaped) {
      *output = (char*)malloc(strlen(escaped) + 1);
      strcpy(*output, escaped);
      curl_free(escaped);
      rc = strlen(*output);
    } 
  }
  return rc;
}

#ifdef __TEST__
int main(int argc, char** argv) {

  if (argc < 2) {
    printf("Usage:  escapetext STRING\n");
    exit(-1);
  }

  char* text = argv[1];
  char* escapedText;

  int rc = 0;
  if (escapeText(text, &escapedText)) {
    printf("Escaped text:  %s\n", escapedText);
  } else {
    printf("Error\n");
    rc = -1;
  }
  free(escapedText);
  exit(rc);

}
#endif
