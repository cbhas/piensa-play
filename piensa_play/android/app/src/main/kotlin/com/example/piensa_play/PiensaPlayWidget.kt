package com.example.piensa_play

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Widget de pantalla de inicio para PiensaPlay
 * Muestra la vizcacha mascota con 3 estados:
 * - pending: No ha respondido hoy (vizcacha normal)
 * - completed: Ya respondió (vizcacha con fuego)
 * - at_risk: En riesgo de perder racha (vizcacha preocupada)
 */
class PiensaPlayWidget : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // Widget agregado por primera vez
    }

    override fun onDisabled(context: Context) {
        // Último widget eliminado
    }

    companion object {
        private const val PREFS_NAME = "HomeWidgetPreferences"
        
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            val prefs: SharedPreferences = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE)
            
            // Leer estado del widget desde SharedPreferences
            val state = prefs.getString("state", "pending") ?: "pending"
            val streak = prefs.getInt("streak", 0)
            
            // Crear RemoteViews
            val views = RemoteViews(context.packageName, R.layout.piensa_play_widget)
            
            // Seleccionar fondo según estado
            val bgResId = when (state) {
                "completed" -> R.drawable.widget_bg_completed
                "at_risk" -> R.drawable.widget_bg_at_risk
                else -> R.drawable.widget_bg_pending
            }
            views.setInt(R.id.widget_container, "setBackgroundResource", bgResId)
            
            // Seleccionar imagen según estado
            val imageResId = when (state) {
                "completed" -> R.drawable.vizcacha_fire
                "at_risk" -> R.drawable.vizcacha_worried
                else -> R.drawable.vizcacha_normal
            }
            views.setImageViewResource(R.id.widget_image, imageResId)
            
            // Actualizar contador de racha
            val streakText = if (state == "completed") "🔥 $streak" else "📚 $streak"
            views.setTextViewText(R.id.widget_streak, streakText)
            
            // Seleccionar mensaje según estado
            val message = when (state) {
                "completed" -> "¡Racha activa!"
                "at_risk" -> "¡No pierdas tu racha!"
                else -> "¡Pregunta del día!"
            }
            views.setTextViewText(R.id.widget_text, message)
            
            // Actualizar widget
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
